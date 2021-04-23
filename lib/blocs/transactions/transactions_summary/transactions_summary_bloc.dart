import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/expense_item.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';

part 'transactions_summary_event.dart';

part 'transactions_summary_state.dart';

class TransactionsSummaryBloc extends Bloc<TransactionsSummaryEvent, TransactionsSummaryState> {
  TransactionsSummaryBloc() : super(TransactionsSummaryInitial());

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  StreamSubscription summaryTransactionsSubscription;

  @override
  Future<void> close() {
    summaryTransactionsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TransactionsSummaryState> mapEventToState(
    TransactionsSummaryEvent event,
    ) async* {
    if (event is TransactionsSummaryInitialize) yield* _mapTransactionsSummaryInitializeToState();
    if (event is TransactionsSummaryGetPreviousMonthPressed) yield* _mapTransactionsSummaryGetPreviousMonthPressedToState();
    if (event is TransactionsSummaryGetNextMonthPressed) yield* _mapTransactionsSummaryGetNextMonthPressedToState();
    if (event is TransactionsSummaryFetchRequested) yield* _mapTransactionsSummaryFetchRequestedToState(dateForFetch: event.dateForFetch);
    if (event is TransactionSummaryDisplayRequested) yield* _mapTransactionSummaryDisplayRequestedToState(event.data, event.expenseSummaryItemEntity);
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryFetchRequestedToState({@required DateTime dateForFetch}) async* {
    summaryTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateFormat('MMMM y').format(_observedDate);
    yield TransactionsSummaryLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    summaryTransactionsSubscription = Future.delayed(Duration(seconds: 2)).asStream().listen((event) {
      // TODO: Implement fetch endpoint
      ExpenseSummaryItemEntity expenseSummaryItemEntity = MockedExpensesItems().generateSummaryData();
      add(TransactionSummaryDisplayRequested(data: _sliderCurrentTimeIntervalString, expenseSummaryItemEntity: expenseSummaryItemEntity));
    });
  }

  Stream<TransactionsSummaryState> _mapTransactionSummaryDisplayRequestedToState(String data, ExpenseSummaryItemEntity expenseSummaryItemEntity) async* {
    yield TransactionsSummaryLoaded(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString, expenseSummaryItemEntity: expenseSummaryItemEntity);
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryInitializeToState() async* {
    _observedDate = DateTime.now();
    add(TransactionsSummaryFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(TransactionsSummaryFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(TransactionsSummaryFetchRequested(dateForFetch: _observedDate));
  }
}