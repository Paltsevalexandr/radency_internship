part of 'transactions_weekly_bloc.dart';


abstract class TransactionsWeeklyEvent extends Equatable {
  const TransactionsWeeklyEvent();
}

class TransactionsWeeklyInitialize extends TransactionsWeeklyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsWeeklyGetPreviousMonthPressed extends TransactionsWeeklyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsWeeklyGetNextMonthPressed extends TransactionsWeeklyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsWeeklyFetchRequested extends TransactionsWeeklyEvent {
  final DateTime dateForFetch;

  TransactionsWeeklyFetchRequested({@required this.dateForFetch});

  @override
  List<Object> get props => [dateForFetch];
}

class TransactionWeeklyDisplayRequested extends TransactionsWeeklyEvent {
  final String data;
  final List<ExpenseWeeklyItemEntity> expenseData;

  TransactionWeeklyDisplayRequested({this.expenseData, @required this.data});

  @override
  List<Object> get props => [data];
}
