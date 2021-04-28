part of 'add_transaction_bloc.dart';

abstract class AddTransactionEvent extends Equatable {
  const AddTransactionEvent();

  @override
  List<Object> get props => throw [];
}

class AddTransactionInitialize extends AddTransactionEvent {}

class AddExpenseTransaction extends AddTransactionEvent {
  final ExpenseTransaction expenseTransaction;
  final bool isAddingCompleted;

  AddExpenseTransaction({@required this.expenseTransaction, @required this.isAddingCompleted});

  @override
  List<Object> get props => [expenseTransaction, isAddingCompleted];
}

class AddTransferTransaction extends AddTransactionEvent {
  final TransferTransaction transferTransaction;
  final bool isAddingCompleted;

  AddTransferTransaction({@required this.transferTransaction, @required this.isAddingCompleted});

  @override
  List<Object> get props => [transferTransaction, isAddingCompleted];
}
