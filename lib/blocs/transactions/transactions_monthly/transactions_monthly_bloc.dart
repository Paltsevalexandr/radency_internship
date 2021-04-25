import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';

import '../../../models/expense_item.dart';
import '../../../utils/mocked_expenses.dart';

part 'transactions_monthly_event.dart';
part 'transactions_monthly_state.dart';

class TransactionsMonthlyBloc extends Bloc<TransactionsMonthlyEvent, TransactionsMonthlyState> {
  TransactionsMonthlyBloc() : super(TransactionsMonthlyInitial());

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  StreamSubscription monthlyTransactionsSubscription;

  @override
  Future<void> close() {
    monthlyTransactionsSubscription?.cancel();
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
    } else  if (event is TransactionMonthlyDisplayRequested) {
      yield* _mapTransactionMonthlyDisplayRequestedToState(event.expenseData);
    }
  }

  Stream<TransactionsMonthlyState> _mapTransactionsMonthlyFetchRequestedToState({@required DateTime dateForFetch}) async* {
    monthlyTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateFormatters().yearFromDateTimeString(_observedDate);
    yield TransactionsMonthlyLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);

    monthlyTransactionsSubscription = Future.delayed(Duration(seconds: 2)).asStream().listen((event) {
      var monthlyData = MockedExpensesItems().generateMonthlyData();
      add(TransactionMonthlyDisplayRequested(expenseData:monthlyData, data: _sliderCurrentTimeIntervalString));
    });
  }

  Stream<TransactionsMonthlyState> _mapTransactionMonthlyDisplayRequestedToState(List<ExpenseMonthlyItemEntity> data) async* {
    yield TransactionsMonthlyLoaded(data: data, sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
  }

  Stream<TransactionsMonthlyState> _mapTransactionsMonthlyInitializeToState() async* {
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
}
