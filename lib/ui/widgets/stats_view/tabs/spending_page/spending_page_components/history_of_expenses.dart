import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';
import 'package:radency_internship_project_2/models/expense_category.dart';

class HistoryOfExpenses extends StatelessWidget {
  HistoryOfExpenses({this.expensesData});
  
  final List<ExpenseCategory> expensesData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Column(
            children: createHistoryOfExpenses(expensesData, state.currency, context),
          );
      })
    );
  }
  List<Widget> createHistoryOfExpenses(expensesData, currency, context) {
    List<Widget> expensesHistory = [];
    for (ExpenseCategory category in expensesData) {
      Widget singleRow;
  
      singleRow = createSingleRow(category, currency, context);
      expensesHistory.add(singleRow);
    }
    return expensesHistory;
  }

  Widget createSingleRow(category, currency, context) {
    String name = category.expenseName;
    double categoryInPercents = category.percents;
    double categoryInCurrency = category.currency;
    Color rgboColor = category.color.rgboColor();
    
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[100], width: pixelsToDP(context, 2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Flexible(flex: 3,
            child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(pixelsToDP(context, 10)),
                  margin: EdgeInsets.only(right: pixelsToDP(context, 12)),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: rgboColor),
                  child: Text('$categoryInPercents%'))),
              Expanded(
                child: Text(name), 
                flex: 3)
            ],
          )),
          Flexible(flex: 1, child: Text('${categoryInCurrency.toString()} $currency')),
      ]));
  }
}
