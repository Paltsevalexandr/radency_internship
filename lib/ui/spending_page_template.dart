import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'spending_page_components/chart.dart';
import '../blocs/expenses/expenses_bloc.dart';
import '../temp_data/expenses_data.dart';
import 'widgets/bottom_nav_bar.dart';

class SpendingPage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.spending)
      ),
      body: Container(
        alignment: Alignment.center,
        child: ExpensesBlocProvider(
          bloc: ExpensesBloc(expensesData),
          child: Chart(),
        )
      ),
      bottomNavigationBar: BottomNavBar(1),
    );
  }
}