part of 'expenses_bloc.dart';

abstract class ExpensesState {
  const ExpensesState({this.expenses});
  final List<ExpenseCategory> expenses;
  
}

class ExpensesInitial extends ExpensesState {
  ExpensesInitial();
}

class ExpensesLoadedState extends ExpensesState {
  const ExpensesLoadedState({this.expenses});
  
  final List<ExpenseCategory> expenses;
}
