part of 'transactions_summary_bloc.dart';

abstract class TransactionsSummaryState extends Equatable {
  const TransactionsSummaryState();

  @override
  List<Object> get props => [];
}

class TransactionsSummaryInitial extends TransactionsSummaryState {}

class TransactionsSummaryLoading extends TransactionsSummaryState {
  final String sliderCurrentTimeIntervalString;

  TransactionsSummaryLoading({@required this.sliderCurrentTimeIntervalString});

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString];
}

class TransactionsSummaryLoaded extends TransactionsSummaryState {
  final String sliderCurrentTimeIntervalString;
  final ExpenseSummaryItemEntity expenseSummaryItemEntity;

  TransactionsSummaryLoaded({this.expenseSummaryItemEntity, @required this.sliderCurrentTimeIntervalString});

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString, expenseSummaryItemEntity];
}
