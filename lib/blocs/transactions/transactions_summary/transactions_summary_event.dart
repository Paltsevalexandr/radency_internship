part of 'transactions_summary_bloc.dart';

abstract class TransactionsSummaryEvent extends Equatable {
  const TransactionsSummaryEvent();
}

class TransactionsSummaryInitialize extends TransactionsSummaryEvent {
  @override
  List<Object> get props => [];
}

class TransactionsSummaryGetPreviousMonthPressed extends TransactionsSummaryEvent {
  @override
  List<Object> get props => [];
}

class TransactionsSummaryGetNextMonthPressed extends TransactionsSummaryEvent {
  @override
  List<Object> get props => [];
}

class TransactionsSummaryFetchRequested extends TransactionsSummaryEvent {
  final DateTime dateForFetch;

  TransactionsSummaryFetchRequested({@required this.dateForFetch});

  @override
  List<Object> get props => [dateForFetch];
}

class TransactionSummaryDisplayRequested extends TransactionsSummaryEvent {
  final String sliderCurrentTimeIntervalString;
  final ExpenseSummaryItemEntity expenseSummaryItemEntity;

  TransactionSummaryDisplayRequested({this.expenseSummaryItemEntity, @required this.sliderCurrentTimeIntervalString});

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString];
}

class TransactionsSummaryLocaleChanged extends TransactionsSummaryEvent {

  @override
  List<Object> get props => [];
}
