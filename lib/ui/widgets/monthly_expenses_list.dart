import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/settings/settings_bloc.dart';
import '../../blocs/transactions/transactions_monthly/transactions_monthly_bloc.dart';
import '../../models/expense_item.dart';
import '../../utils/strings.dart';
import '../../utils/ui_utils.dart';
import 'common_expenses_list.dart';

Widget buildMonthlyExpensesList(BuildContext context) {
  return BlocBuilder<TransactionsMonthlyBloc, TransactionsMonthlyState>(
      builder: (context, state) {
    if (state is TransactionsMonthlyLoaded) {
      var data = state.data;

      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: MonthlyExpensesItem(itemEntity: data[index]),
          );
        },
      );
    }

    return null;
  });
}

class MonthlyExpensesItem extends StatelessWidget {
  const MonthlyExpensesItem({
    Key key,
    this.itemEntity,
  }) : super(key: key);

  final ExpenseMonthlyItemEntity itemEntity;

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
                width: pixelsToDP(context, 180.0),
                child: Padding(
                  padding: EdgeInsets.only(right: pixelsToDP(context, 8.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: greyColor, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Text(
                      '${getMonthByNumber(context, itemEntity.monthNumber)}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: greyColor, fontSize: 18),
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
