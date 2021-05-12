import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/expenses/expenses_bloc.dart';
import 'history_of_expenses.dart';
import 'chart.dart';

class SpendingsPageView extends StatelessWidget {

  Widget build(BuildContext context) {

    return BlocBuilder<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        if(state.expenses == null) {
          return Container();
        }
        return SingleChildScrollView(child: Column(
          children: [
            PieOutsideLabelChart(expensesData: state.expenses),
            HistoryOfExpenses(expensesData: state.expenses),
          ]
        ));
      });
  }
}
