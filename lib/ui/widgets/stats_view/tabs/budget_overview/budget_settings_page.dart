import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class BudgetSettingsPage extends StatefulWidget {
  @override
  _BudgetSettingsPageState createState() => _BudgetSettingsPageState();
}

class _BudgetSettingsPageState extends State<BudgetSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.statsBudgetViewBudgetSettingsTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
              MockedExpensesItems().expenseCategories.length,
              (index) => Column(
                    children: [
                      Divider(),
                      categoryItem(context, MockedExpensesItems().expenseCategories[index]),
                    ],
                  )),
        ),
      ),
    );
  }

  Widget categoryItem(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.all(pixelsToDP(context, 24)),
      child: GestureDetector(
        child: Container(
          width: double.maxFinite,
          child: Row(
            children: [
              SizedBox(
                width: pixelsToDP(context, 30),
              ),
              Expanded(
                child: Text(
                  title,
                  style: budgetItemUnlimitedTitleStyle,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(Routes.categoryBudgetSetupView, arguments: title);
        },
      ),
    );
  }
}
