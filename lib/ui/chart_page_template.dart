import 'package:flutter/material.dart';
import '../chart/chart.dart';
import '../blocs/expenses/expenses_bloc.dart';
import '../temp_data/expenses_data.dart';

class ChartPage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chart')
      ),
      body: Container(
        alignment: Alignment.center,
        child: ExpensesBlocProvider(
          bloc: ExpensesBloc(expensesData),
          child: Chart(),
        )
      )
    );
  }
}