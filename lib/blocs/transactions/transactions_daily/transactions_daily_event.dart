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

class TransactionDailyDisplayRequested extends TransactionsDailyEvent {
  final String data;

  TransactionDailyDisplayRequested({@required this.data});

  @override
  List<Object> get props => [data];
}
