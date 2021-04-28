import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/blocs/stats/expenses/expenses_bloc.dart';
import 'package:radency_internship_project_2/temp_data/expenses_data.dart';
import 'package:radency_internship_project_2/ui/spending_page_components/chart.dart';

class SpendingPage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: ExpensesBlocProvider(
          bloc: ExpensesBloc(expensesData),
          child: Chart(),
        )
    );
  }
}