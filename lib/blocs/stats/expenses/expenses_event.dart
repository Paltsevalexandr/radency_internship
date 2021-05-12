part of 'expenses_bloc.dart';

abstract class ExpensesEvent {
  const ExpensesEvent();
}

class ExpensesLoaded extends ExpensesEvent {
  const ExpensesLoaded({this.expenses});

  final List<Map<String, double>> expenses;
}
