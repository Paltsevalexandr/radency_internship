part of 'transactions_monthly_bloc.dart';


abstract class TransactionsMonthlyEvent extends Equatable {
  const TransactionsMonthlyEvent();
}

class TransactionsMonthlyInitialize extends TransactionsMonthlyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsMonthlyGetPreviousYearPressed extends TransactionsMonthlyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsMonthlyGetNextYearPressed extends TransactionsMonthlyEvent {
  @override
  List<Object> get props => [];
}

class TransactionsMonthlyFetchRequested extends TransactionsMonthlyEvent {
  final DateTime dateForFetch;

  TransactionsMonthlyFetchRequested({@required this.dateForFetch});

  @override
  List<Object> get props => [dateForFetch];
}

class TransactionMonthlyDisplayRequested extends TransactionsMonthlyEvent {
  final String data;
  final List<ExpenseMonthlyItemEntity> expenseData;

  TransactionMonthlyDisplayRequested({this.expenseData, @required this.data});

  @override
  List<Object> get props => [data];
}
