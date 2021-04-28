part of 'transactions_daily_bloc.dart';

abstract class TransactionsDailyEvent extends Equatable {
  const TransactionsDailyEvent();
}

class TransactionsDailyInitialize extends TransactionsDailyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsDailyGetPreviousMonthPressed extends TransactionsDailyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsDailyGetNextMonthPressed extends TransactionsDailyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsDailyFetchRequested extends TransactionsDailyEvent {
  final DateTime dateForFetch;

  TransactionsDailyFetchRequested({@required this.dateForFetch});

  @override
  List<Object> get props => [dateForFetch];
}

class TransactionsDailyDisplayRequested extends TransactionsDailyEvent {
  final String data;
  final Map<int, List<ExpenseItemEntity>> expenseData;

  TransactionsDailyDisplayRequested({this.expenseData, @required this.data});

  @override
  List<Object> get props => [data];
}
