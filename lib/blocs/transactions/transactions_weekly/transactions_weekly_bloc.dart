import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'transactions_weekly_event.dart';

part 'transactions_weekly_state.dart';

class TransactionsWeeklyBloc extends Bloc<TransactionsWeeklyEvent, TransactionsWeeklyState> {
  TransactionsWeeklyBloc() : super(TransactionsWeeklyInitial());

  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  final int startOfWeek = 1;
  final int endOfWeek = 7;

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  StreamSubscription weeklyTransactionsSubscription;

  @override
  Future<void> close() {
    weeklyTransactionsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TransactionsWeeklyState> mapEventToState(
    TransactionsWeeklyEvent event,
  ) async* {
    if (event is TransactionsWeeklyInitialize) yield* _mapTransactionsWeeklyInitializeToState();
    if (event is TransactionsWeeklyGetPreviousMonthPressed) yield* _mapTransactionsWeeklyGetPreviousMonthPressedToState();
    if (event is TransactionsWeeklyGetNextMonthPressed) yield* _mapTransactionsWeeklyGetNextMonthPressedToState();
    if (event is TransactionsWeeklyFetchRequested) yield* _mapTransactionsWeeklyFetchRequestedToState(dateForFetch: event.dateForFetch);
    if (event is TransactionWeeklyDisplayRequested) yield* _mapTransactionWeeklyDisplayRequestedToState(event.data);
  }

  Stream<TransactionsWeeklyState> _mapTransactionsWeeklyFetchRequestedToState({@required DateTime dateForFetch}) async* {
    weeklyTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = getWeeksRange(dateForFetch);
    yield TransactionsWeeklyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);

    weeklyTransactionsSubscription = Future.delayed(Duration(seconds: 2)).asStream().listen((event) {
      add(TransactionWeeklyDisplayRequested(data: _sliderCurrentTimeIntervalString));
    });
  }

  Stream<TransactionsWeeklyState> _mapTransactionWeeklyDisplayRequestedToState(String data) async* {
    yield TransactionsWeeklyLoaded(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
  }

  Stream<TransactionsWeeklyState> _mapTransactionsWeeklyInitializeToState() async* {
    _observedDate = DateTime.now();
    add(TransactionsWeeklyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsWeeklyState> _mapTransactionsWeeklyGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(TransactionsWeeklyFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsWeeklyState> _mapTransactionsWeeklyGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(TransactionsWeeklyFetchRequested(dateForFetch: _observedDate));
  }

  String getWeeksRange(DateTime dateTime) {
    String range = '';

    DateTime startOfFirstWeekForCurrentMonth = DateTime(dateTime.year, dateTime.month, 1);
    while (startOfFirstWeekForCurrentMonth.weekday != startOfWeek) {
      startOfFirstWeekForCurrentMonth =
          DateTime(startOfFirstWeekForCurrentMonth.year, startOfFirstWeekForCurrentMonth.month, startOfFirstWeekForCurrentMonth.day - 1);
    }

    DateTime endOfLastWeekForCurrentMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    while (endOfLastWeekForCurrentMonth.weekday != endOfWeek) {
      endOfLastWeekForCurrentMonth = DateTime(endOfLastWeekForCurrentMonth.year, endOfLastWeekForCurrentMonth.month, endOfLastWeekForCurrentMonth.day + 1);
    }

    range = '${appendZeroToSingleDigit(startOfFirstWeekForCurrentMonth.day)}.'
        '${appendZeroToSingleDigit(startOfFirstWeekForCurrentMonth.month)}'
        '${startOfFirstWeekForCurrentMonth.year != endOfLastWeekForCurrentMonth.year ? '.${startOfFirstWeekForCurrentMonth.year}' : ''}'
        ' ~ '
        '${appendZeroToSingleDigit(endOfLastWeekForCurrentMonth.day)}.'
        '${appendZeroToSingleDigit(endOfLastWeekForCurrentMonth.month)}'
        '.${endOfLastWeekForCurrentMonth.year}';

    return range;
  }

  String appendZeroToSingleDigit(int number) {
    return '${number < 10 ? '0' : ''}${number.toString()}';
  }
}
