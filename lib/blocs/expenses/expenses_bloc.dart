import 'package:flutter/material.dart';
import 'dart:async';

abstract class Bloc {
  void dispose();
}

class ExpensesBloc implements Bloc {

  List<Map<String, double>> expenses;

  ExpensesBloc(this.expenses);

  final _expensesStreamController = StreamController();

  Stream get expensesStream => _expensesStreamController.stream;
  Sink get expensesSink => _expensesStreamController.sink;

  void dispose() {
    _expensesStreamController.close();
  }
}

class ExpensesBlocProvider<T extends Bloc> extends StatefulWidget {
  ExpensesBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final T bloc;
  final Widget child;

  @override
  _ExpensesBlocProviderState createState() => _ExpensesBlocProviderState();

  static T of<T extends Bloc>(BuildContext context){
    ExpensesBlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }
}

class _ExpensesBlocProviderState extends State<ExpensesBlocProvider> {
  @override
  void dispose(){
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return widget.child;
  }
}
