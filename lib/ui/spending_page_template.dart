import 'package:flutter/material.dart';
import 'spending_page_components/chart.dart';
import '../blocs/expenses/expenses_bloc.dart';
import '../temp_data/expenses_data.dart';
import 'bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpendingPage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).spending)
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