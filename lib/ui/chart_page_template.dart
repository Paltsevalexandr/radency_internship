import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/blocs/expenses/expenses_bloc.dart';
import 'package:radency_internship_project_2/temp_data/expenses_data.dart';
import 'package:radency_internship_project_2/ui/widgets/chart.dart';

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