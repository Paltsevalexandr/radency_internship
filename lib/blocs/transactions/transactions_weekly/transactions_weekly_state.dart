part of 'transactions_weekly_bloc.dart';

abstract class TransactionsWeeklyState extends Equatable {
  const TransactionsWeeklyState();

  @override
  List<Object> get props => [];
}

class TransactionsWeeklyInitial extends TransactionsWeeklyState {}

class TransactionsWeeklyLoading extends TransactionsWeeklyState {
  final String sliderCurrentTimeIntervalString;

  TransactionsWeeklyLoading({@required this.sliderCurrentTimeIntervalString});

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString];
}

class TransactionsWeeklyLoaded extends TransactionsWeeklyState {
  final String sliderCurrentTimeIntervalString;
  final List<ExpenseWeeklyItemEntity> data;

  TransactionsWeeklyLoaded({this.data, @required this.sliderCurrentTimeIntervalString});

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString];
}
