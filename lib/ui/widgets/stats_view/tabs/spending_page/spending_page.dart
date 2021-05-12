import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/expenses/expenses_bloc.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/spending_page/spending_page_components/spendings_page_view.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';

class SpendingPage extends StatelessWidget {
  
  Widget build(BuildContext context) {
    List<Map<String, double>> expensesData = MockedExpensesItems().summaryExpensesByCategories();

    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: BlocProvider(
          create: (_) => ExpensesBloc()..add(ExpensesLoaded(expenses: expensesData)),
          child: SpendingsPageView(),
        )
    ));
  }
}