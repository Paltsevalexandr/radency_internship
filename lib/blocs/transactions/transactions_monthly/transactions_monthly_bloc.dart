import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/month_details.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/user.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/repositories/transactions_repository.dart';
import 'package:radency_internship_project_2/utils/date_helper.dart';

part 'transactions_monthly_event.dart';

part 'transactions_monthly_state.dart';

class TransactionsMonthlyBloc extends Bloc<TransactionsMonthlyEvent, TransactionsMonthlyState> {
  TransactionsMonthlyBloc({
    @required this.transactionsRepository,
    @required this.firebaseAuthenticationService,
  }) : super(TransactionsMonthlyInitial());

  final FirebaseAuthenticationService firebaseAuthenticationService;
  final TransactionsRepository transactionsRepository;

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  List<Transaction> observedYearTransactions = [];
  List<MonthDetails> yearSummary = [];

  StreamSubscription<UserEntity> _onUserChangedSubscription;
  StreamSubscription monthlyTransactionsSubscription;

  @override
  Future<void> close() {
    monthlyTransactionsSubscription?.cancel();
    _onUserChangedSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TransactionsMonthlyState> mapEventToState(
    TransactionsMonthlyEvent event,
  ) async* {
    if (event is TransactionsMonthlyInitialize) {
      yield* _mapTransactionsMonthlyInitializeToState();
    } else if (event is TransactionsMonthlyGetPreviousYearPressed) {
      yield* _mapTransactionsMonthlyGetPreviousYearPressedToState();
    } else if (event is TransactionsMonthlyGetNextYearPressed) {
      yield* _mapTransactionsMonthlyGetNextYearPressedToState();
    } else if (event is TransactionsMonthlyFetchRequested) {
      yield* _mapTransactionsMonthlyFetchRequestedToState(dateForFetch: event.dateForFetch);
    } else if (event is TransactionMonthlyDisplayRequested) {
      yield* _mapTransactionMonthlyDisplayRequestedToState(event.yearTransactions);
    } else if (event is TransactionMonthlyRefreshPressed) {
      add(TransactionsMonthlyFetchRequested(dateForFetch: _observedDate));
    }
  }

  Stream<TransactionsMonthlyState> _mapTransactionsMonthlyFetchRequestedToState(
      {@required DateTime dateForFetch}) async* {
    monthlyTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateHelper().yearFromDateTimeString(_observedDate);
    yield TransactionsMonthlyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    monthlyTransactionsSubscription = transactionsRepository
        .getTransactionsByTimePeriod(
          start: DateHelper().getFirstDayOfYear(dateForFetch),
          end: DateHelper().getLastDayOfYear(dateForFetch),
        )
        .asStream()
        .listen((event) {
      observedYearTransactions = event;
      add(TransactionMonthlyDisplayRequested(
          yearTransactions: observedYearTransactions,
          sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString));
    });
  }

  Stream<TransactionsMonthlyState> _mapTransactionMonthlyDisplayRequestedToState(List<Transaction> data) async* {
    yearSummary = _getSummaryFromTransactionsList(data);

    yield TransactionsMonthlyLoaded(
        yearSummary: yearSummary, sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
  }

  Stream<TransactionsMonthlyState> _mapTransactionsMonthlyInitializeToState() async* {
    _onUserChangedSubscription = firebaseAuthenticationService.userFromAuthState.listen((user) {
      if (user == UserEntity.empty) {
        observedYearTransactions.clear();
        add(TransactionMonthlyDisplayRequested(
            sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
            yearTransactions: observedYearTransactions));
      } else {
        _observedDate = DateTime.now();
        add(TransactionsMonthlyFetchRequested(dateForFetch: _observedDate));
      }
    });

    _observedDate = DateTime.now();
    add(TransactionsMonthlyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsMonthlyState> _mapTransactionsMonthlyGetPreviousYearPressedToState() async* {
    _observedDate = DateTime(_observedDate.year - 1);
    add(TransactionsMonthlyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsMonthlyState> _mapTransactionsMonthlyGetNextYearPressedToState() async* {
    _observedDate = DateTime(
      _observedDate.year + 1,
    );
    add(TransactionsMonthlyFetchRequested(dateForFetch: _observedDate));
  }

  List<MonthDetails> _getSummaryFromTransactionsList(List<Transaction> data) {
    List<MonthDetails> list = [];

    if (data.isEmpty) return list;

    for (int i = 1; i <= 12; i++) {
      list.add(MonthDetails(monthNumber: i, income: 0.0, expenses: 0.0));
    }

    data.forEach((transaction) {
      if (transaction is ExpenseTransaction) {
        list.where((monthSummary) => monthSummary.monthNumber == transaction.date.month).first.expenses +=
            transaction.amount;
      } else if (transaction is IncomeTransaction) {
        list.where((monthSummary) => monthSummary.monthNumber == transaction.date.month).first.income +=
            transaction.amount;
      }
    });

    list.removeWhere((element) => (element.income == 0.0 && element.expenses == 0.0));

    return list;
  }
}
