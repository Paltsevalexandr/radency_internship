import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transactions_helper.dart';
import 'package:radency_internship_project_2/models/user.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/providers/firebase_realtime_database_provider.dart';
import 'package:radency_internship_project_2/repositories/transactions_repository.dart';
import 'package:radency_internship_project_2/utils/date_helper.dart';

part 'transactions_daily_event.dart';

part 'transactions_daily_state.dart';

class TransactionsDailyBloc extends Bloc<TransactionsDailyEvent, TransactionsDailyState> {
  TransactionsDailyBloc({
    @required this.settingsBloc,
    @required this.transactionsRepository,
    @required this.firebaseAuthenticationService,
    @required this.firebaseRealtimeDatabaseProvider,
  }) : super(TransactionsDailyInitial());

  final FirebaseAuthenticationService firebaseAuthenticationService;
  final TransactionsRepository transactionsRepository;
  final FirebaseRealtimeDatabaseProvider firebaseRealtimeDatabaseProvider;

  SettingsBloc settingsBloc;
  StreamSubscription settingsSubscription;
  String locale = '';

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  List<Transaction> dailyData = [];

  StreamSubscription dailyTransactionsSubscription;

  StreamSubscription<Event> _onTransactionAddedSubscription;
  StreamSubscription<Event> _onTransactionChangedSubscription;
  StreamSubscription<Event> _onTransactionDeletedSubscription;
  StreamSubscription<UserEntity> _onUserChangedSubscription;

  @override
  Future<void> close() {
    dailyTransactionsSubscription?.cancel();
    settingsSubscription?.cancel();
    _onTransactionChangedSubscription?.cancel();
    _onTransactionAddedSubscription?.cancel();
    _onTransactionDeletedSubscription?.cancel();
    _onUserChangedSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TransactionsDailyState> mapEventToState(
    TransactionsDailyEvent event,
  ) async* {
    if (event is TransactionsDailyInitialize) {
      yield* _mapTransactionsDailyInitializeToState();
    } else if (event is TransactionsDailyGetPreviousMonthPressed) {
      yield* _mapTransactionsDailyGetPreviousMonthPressedToState();
    } else if (event is TransactionsDailyGetNextMonthPressed) {
      yield* _mapTransactionsDailyGetNextMonthPressedToState();
    } else if (event is TransactionsDailyFetchRequested) {
      yield* _mapTransactionsDailyFetchRequestedToState(dateForFetch: event.dateForFetch);
    } else if (event is TransactionsDailyDisplayRequested) {
      yield* _mapTransactionDailyDisplayRequestedToState(event.transactions);
    } else if (event is TransactionsDailyLocaleChanged) {
      yield* _mapTransactionsDailyLocaleChangedToState();
    } else if (event is TransactionDailyUserChanged) {
      yield* _mapTransactionDailyUserChangedToState(event.id);
    } else if (event is TransactionDailyDelete) {
      yield* _mapTransactionDailyDeleteToState(event.transactionId);
    }
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyInitializeToState() async* {
    _observedDate = DateTime.now();

    _onUserChangedSubscription = firebaseAuthenticationService.userFromAuthState.listen((user) {
      _onTransactionChangedSubscription?.cancel();
      _onTransactionAddedSubscription?.cancel();
      _onTransactionDeletedSubscription?.cancel();

      if (user == UserEntity.empty) {
        dailyData.clear();
        add(TransactionsDailyDisplayRequested(
            sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString, transactions: dailyData));
      } else {
        add(TransactionDailyUserChanged(id: user.id));
      }
    });

    if (settingsBloc.state is LoadedSettingsState) {
      locale = settingsBloc.state.language;
    }
    settingsBloc.stream.listen((newSettingsState) {
      print("TransactionsDailyBloc._mapTransactionsDailyInitializeToState: newSettingsState");
      if (newSettingsState is LoadedSettingsState && newSettingsState.language != locale) {
        locale = newSettingsState.language;
        add(TransactionsDailyLocaleChanged());
      }
    });
  }

  Stream<TransactionsDailyState> _mapTransactionDailyUserChangedToState(String id) async* {
    yield TransactionsDailyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);

    FirebaseStreamsGroup streams = await firebaseRealtimeDatabaseProvider.transactionStreams(id);
    _onTransactionAddedSubscription = streams.onChildAdded.listen(_onTransactionAdded);
    _onTransactionChangedSubscription = streams.onChildChanged.listen(_onTransactionChanged);
    _onTransactionDeletedSubscription = streams.onChildDeleted.listen(_onTransactionDeleted);

    _observedDate = DateTime.now();

    add(TransactionsDailyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyLocaleChangedToState() async* {
    _sliderCurrentTimeIntervalString = DateHelper().monthNameAndYearFromDateTimeString(_observedDate, locale: locale);

    print("TransactionsDailyBloc._mapTransactionsDailyLocaleChangedToState: $_sliderCurrentTimeIntervalString");

    if (state is TransactionsDailyLoaded) {
      add(TransactionsDailyDisplayRequested(
          transactions: dailyData, sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString));
    } else if (state is TransactionsDailyLoading) {
      yield TransactionsDailyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    }
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyFetchRequestedToState({@required DateTime dateForFetch}) async* {
    dailyTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateHelper().monthNameAndYearFromDateTimeString(_observedDate);
    yield TransactionsDailyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    dailyTransactionsSubscription = transactionsRepository
        .getTransactionsByTimePeriod(
            start: DateHelper().getFirstDayOfMonth(_observedDate), end: DateHelper().getLastDayOfMonth(_observedDate))
        .asStream()
        .listen((event) {
      dailyData = event;
      add(TransactionsDailyDisplayRequested(
          transactions: dailyData, sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString));
    });
  }

  Stream<TransactionsDailyState> _mapTransactionDailyDisplayRequestedToState(List<Transaction> data) async* {
    yield TransactionsDailyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    Map<int, List<Transaction>> map = sortTransactionsByDays(dailyData);
    yield TransactionsDailyLoaded(
        dailySortedTransactions: map, sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
  }

  Stream<TransactionsDailyState> _mapTransactionDailyDeleteToState(String transactionId) async* {
    transactionsRepository.delete(transactionID: transactionId);
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(TransactionsDailyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(TransactionsDailyFetchRequested(dateForFetch: _observedDate));
  }

  _onTransactionAdded(Event event) async {
    print('TransactionsBloc: snapshot ${event.snapshot}');
    Transaction transaction = TransactionsHelper()
        .convertJsonToTransaction(json: Map<String, dynamic>.from(event.snapshot.value), key: event.snapshot.key);

    // TODO: split this into readable appearance..
    if ((transaction.date.isAfter(DateHelper().getFirstDayOfMonth(_observedDate)) ||
            transaction.date == DateHelper().getFirstDayOfMonth(_observedDate)) &&
        transaction.date.isBefore(DateHelper().getLastDayOfMonth(_observedDate)) &&
        dailyData.indexWhere((element) => element.id == transaction.id) == -1) {
      dailyData.add(transaction);
      add(TransactionsDailyDisplayRequested(
          sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString, transactions: dailyData));
    }
  }

  _onTransactionChanged(Event event) async {
    int oldTransactionIndex = dailyData.indexWhere((transaction) => transaction.id == event.snapshot.key);
    Transaction changedTransaction = TransactionsHelper()
        .convertJsonToTransaction(json: Map<String, dynamic>.from(event.snapshot.value), key: event.snapshot.key);
    if (oldTransactionIndex != -1) {
      dailyData[oldTransactionIndex] = changedTransaction;
    }
    add(TransactionsDailyDisplayRequested(
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString, transactions: dailyData));
  }

  _onTransactionDeleted(Event event) async {
    int index = dailyData.indexWhere((transaction) => transaction.id == event.snapshot.key);
    if (index != -1) {
      dailyData.removeAt(index);
    }

    add(TransactionsDailyDisplayRequested(
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString, transactions: dailyData));
  }

  Map<int, List<Transaction>> sortTransactionsByDays(List<Transaction> list) {
    SplayTreeMap<int, List<Transaction>> map = SplayTreeMap();

    list.forEach((element) {
      if (!map.containsKey(element.date.day)) {
        map[element.date.day] = [element];
      } else {
        map[element.date.day].add(element);
      }
    });

    return map;
  }
}
