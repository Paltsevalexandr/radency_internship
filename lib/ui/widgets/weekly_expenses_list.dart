import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/utils/time.dart';

import '../../blocs/settings/settings_bloc.dart';
import '../../blocs/transactions/transactions_monthly/transactions_monthly_bloc.dart';
import '../../blocs/transactions/transactions_weekly/transactions_weekly_bloc.dart';
import '../../blocs/transactions/transactions_weekly/transactions_weekly_bloc.dart';
import '../../models/expense_item.dart';
import '../../utils/strings.dart';
import '../../utils/ui_utils.dart';
import 'common_expenses_list.dart';
import 'monthly_expenses_list.dart';

Widget buildWeeklyExpensesList(BuildContext context) {
  return BlocBuilder<TransactionsWeeklyBloc, TransactionsWeeklyState>(
      builder: (context, state) {
    if (state is TransactionsWeeklyLoaded) {
      var data = state.data;

      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: WeeklyExpensesItem(itemEntity: data[index]),
          );
        },
      );
    }

    return null;
  });
}

class WeeklyExpensesItem extends StatelessWidget {
  const WeeklyExpensesItem({
    Key key,
    this.itemEntity,
  }) : super(key: key);

  final ExpenseWeeklyItemEntity itemEntity;

  @override
  Widget build(BuildContext context) {
    const greyColor = Color(0xff8d8d8d);

    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      String currency = state.currency;
      return Container(
          height: pixelsToDP(context, 150),
          child: Row(
            children: [
              SizedBox(
                width: pixelsToDP(context, 330.0),
                child: Padding(
                  padding: EdgeInsets.only(
                      right: pixelsToDP(context, 12.0),
                      left: pixelsToDP(context, 12.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: greyColor, width: 1.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(pixelsToDP(context, 12.0))),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(pixelsToDP(context, 12.0)),
                      child: Text(
                        '${getWeekStartToEndDateByWeekNumber(itemEntity.weekNumber)}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: greyColor, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              buildIncomeText(context, getCurrencySymbol(currency), itemEntity.income),
              buildOutcomeText(context, getCurrencySymbol(currency), itemEntity.outcome)
            ],
          ));
    });
  }
}
