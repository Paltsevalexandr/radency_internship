import 'package:flutter/material.dart';
import 'chart_page_components/chart.dart';
import '../blocs/expenses/expenses_bloc.dart';
import '../temp_data/expenses_data.dart';
import 'bottom_nav_bar/bottom_nav_bar.dart';

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
      ),
      bottomNavigationBar: BottomNavBar(1),
    );
  }
}