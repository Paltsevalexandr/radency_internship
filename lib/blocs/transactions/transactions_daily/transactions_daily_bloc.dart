import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';

part 'transactions_daily_event.dart';
part 'transactions_daily_state.dart';

class TransactionsDailyBloc extends Bloc<TransactionsDailyEvent, TransactionsDailyState> {
  TransactionsDailyBloc() : super(TransactionsDailyInitial());

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  StreamSubscription dailyTransactionsSubscription;

  @override
  Future<void> close() {
    dailyTransactionsSubscription?.cancel();
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
    } else if (event is TransactionDailyDisplayRequested) {
      yield* _mapTransactionDailyDisplayRequestedToState(event.data);
    }
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyFetchRequestedToState({@required DateTime dateForFetch}) async* {
    dailyTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateFormatters().monthNameAndYearFromDateTimeString(_observedDate);
    yield TransactionsDailyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    dailyTransactionsSubscription = Future.delayed(Duration(seconds: 2)).asStream().listen((event) {
      // TODO: Implement fetch endpoint

      add(TransactionDailyDisplayRequested(data: _sliderCurrentTimeIntervalString));
    });
  }

  Stream<TransactionsDailyState> _mapTransactionDailyDisplayRequestedToState(String data) async* {
    yield TransactionsDailyLoaded(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyInitializeToState() async* {
    _observedDate = DateTime.now();
    add(TransactionsDailyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(TransactionsDailyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsDailyState> _mapTransactionsDailyGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(TransactionsDailyFetchRequested(dateForFetch: _observedDate));
  }
}
