part of 'transactions_monthly_bloc.dart';

abstract class TransactionsMonthlyState extends Equatable {
  const TransactionsMonthlyState();

  @override
  List<Object> get props => [];
}

class TransactionsMonthlyInitial extends TransactionsMonthlyState {}

class TransactionsMonthlyLoading extends TransactionsMonthlyState {
  final String sliderCurrentTimeIntervalString;

  TransactionsMonthlyLoading({@required this.sliderCurrentTimeIntervalString});

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString];
}

class TransactionsMonthlyLoaded extends TransactionsMonthlyState {
  final String sliderCurrentTimeIntervalString;
  final List<ExpenseMonthlyItemEntity> data;

  TransactionsMonthlyLoaded({this.data, @required this.sliderCurrentTimeIntervalString});

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString];
}
