part of 'add_transaction_bloc.dart';

abstract class AddTransactionState extends Equatable {
  const AddTransactionState();

  @override
  List<Object> get props => [];
}

class AddTransactionInitial extends AddTransactionState {}

class AddTransactionLoaded extends AddTransactionState {
  final List<String> categories;
  final List<String> accounts;


  AddTransactionLoaded({@required this.categories, @required this.accounts});

  @override
  List<Object> get props => [categories, accounts];
}

class AddTransactionSuccessfulAndCompleted extends AddTransactionState {}

class AddTransactionSuccessfulAndContinued extends AddTransactionState {}
