import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/models/budget/monthly_category_expense.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class ExpenseCategoryBudgetItem extends StatelessWidget {
  final MonthlyCategoryExpense monthlyCategoryExpense;

  final double progressIndicatorHeight = 80;
  final double verticalPadding = 24;
  final double horizontalPadding = 40;

  ExpenseCategoryBudgetItem({@required this.monthlyCategoryExpense});

  @override
  Widget build(BuildContext context) {
    if (monthlyCategoryExpense.budgetTotal == 0) {
      return _budgetUnlimitedCategoryItem(context);
    } else {
      return _budgetLimitedCategoryItem();
    }
  }

  Widget _budgetLimitedCategoryItem() {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, verticalPadding), horizontal: pixelsToDP(context, horizontalPadding)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: _budgetLimitedCategoryTitleAndExpense(),
              ),
              Flexible(
                flex: 3,
                child: budgetLimitedProgressBar(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _budgetLimitedCategoryTitleAndExpense() {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              monthlyCategoryExpense.category,
              style: budgetItemLimitedAndRemainingTitleStyle,
            ),
            Text(
              '${getCurrencySymbol(state.currency)} ${monthlyCategoryExpense.budgetTotal.toStringAsFixed(2)}',
              style: budgetItemLimitedTotalBudgetAmountStyle,
            )
          ],
        );
      },
    );
  }

  Widget budgetLimitedProgressBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(pixelsToDP(context, 10))),
          child: Stack(
            children: [
              LinearProgressIndicator(
                minHeight: pixelsToDP(context, progressIndicatorHeight),
                backgroundColor: Colors.grey.shade300,
                value: monthlyCategoryExpense.budgetUsage,
                valueColor: monthlyCategoryExpense.budgetUsage < 1 ? AlwaysStoppedAnimation<Color>(Colors.blue) : AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              Container(
                  alignment: Alignment(0.95, 0),
                  height: pixelsToDP(context, progressIndicatorHeight),
                  child: Text(
                    '${(monthlyCategoryExpense.budgetUsage * 100).toStringAsFixed(0)}%',
                    style: budgetItemLimitedTotalBudgetAmountStyle,
                  )),
            ],
          ),
        ),
        Container(
          width: double.maxFinite,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(
                '${monthlyCategoryExpense.expenseAmount.toStringAsFixed(2)}',
                style: budgetItemLimitedExpenseAmountStyle(isOverBudget: monthlyCategoryExpense.expenseAmount > monthlyCategoryExpense.budgetTotal),
              ),
              Text(
                monthlyCategoryExpense.budgetLeft.toStringAsFixed(2),
                style: budgetItemLimitedTotalBudgetAmountStyle,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _budgetUnlimitedCategoryItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, verticalPadding), horizontal: pixelsToDP(context, horizontalPadding)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            monthlyCategoryExpense.category,
            style: budgetItemUnlimitedTitleStyle,
          ),
          Text(
            monthlyCategoryExpense.expenseAmount.toStringAsFixed(2),
            style: budgetItemUnlimitedExpenseAmountStyle,
          )
        ],
      ),
    );
  }
}
