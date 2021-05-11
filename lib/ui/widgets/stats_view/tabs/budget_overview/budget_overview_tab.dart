import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/budget_overview/budget_overview_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/budget/monthly_category_expense.dart';
import 'package:radency_internship_project_2/ui/shared_components/elevated_buttons/colored_elevated_button.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/budget_overview/widgets/budget_slider.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/budget_overview/widgets/expense_category_budget_card.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class BudgetOverviewTab extends StatefulWidget {
  @override
  _BudgetOverviewTabState createState() => _BudgetOverviewTabState();
}

class _BudgetOverviewTabState extends State<BudgetOverviewTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        BudgetSlider(),
        Expanded(child: budgetOverview()),
      ],
    );
  }

  Widget budgetOverview() {
    return BlocBuilder<BudgetOverviewBloc, BudgetOverviewState>(
      builder: (context, state) {
        if (state is BudgetOverviewLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is BudgetOverviewLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              summaryAndSettingsButton(state.summary),
              SizedBox(
                height: pixelsToDP(context, 30),
              ),
              categoriesBudgetList(state.monthlyCategoryExpenses),
            ],
          );
        }

        return SizedBox();
      },
    );
  }

  Widget summaryAndSettingsButton(MonthlyCategoryExpense summary) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(pixelsToDP(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(pixelsToDP(context, 34)),
              child: Container(
                width: double.maxFinite,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    remainingBudgetSection(),
                    settingsButton(),
                  ],
                ),
              ),
            ),
            ExpenseCategoryBudgetItem(monthlyCategoryExpense: summary),
          ],
        ),
      ),
    );
  }

  Widget remainingBudgetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.current.statsBudgetViewRemainingMonthlyTitle, style: budgetItemLimitedAndRemainingTitleStyle),
        BlocBuilder<BudgetOverviewBloc, BudgetOverviewState>(builder: (context, budgetOverviewState) {
          if (budgetOverviewState is BudgetOverviewLoaded) {
            return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, settingsState) {
              return Text(
                '${getCurrencySymbol(settingsState.currency)} ${budgetOverviewState.summary.budgetLeft.toStringAsFixed(2)}',
                style: budgetSummaryRemainingAmountStyle,
              );
            });
          }

          return Text('');
        }),
      ],
    );
  }

  Widget settingsButton() {
    return ColoredElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.budgetSettings);
        },
        child: Text(S.current.statsBudgetViewBudgetSettingsTitle));
  }

  Widget categoriesBudgetList(List<MonthlyCategoryExpense> monthlyCategoryExpenses) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          // mainAxisSize: MainAxisSize.min,
          children: List.generate(
              monthlyCategoryExpenses.length,
              (index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index != 0) Divider(),
                      ExpenseCategoryBudgetItem(monthlyCategoryExpense: monthlyCategoryExpenses[index]),
                    ],
                  )),
        ),
      ),
    );
  }
}
