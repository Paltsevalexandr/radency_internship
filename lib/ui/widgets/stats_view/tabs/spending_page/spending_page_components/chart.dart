import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/expenses/expenses_bloc.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';

class Chart extends StatelessWidget {
  List<PieChartSectionData> createSections(expensesData, context) {
    List<PieChartSectionData> chartSections = [for (Map expenseType in expensesData) createSingleChartSection(expenseType, context)];
    return chartSections;
  }

  PieChartSectionData createSingleChartSection(Map expenseType, context) {
    PieChartSectionData singleSection;

    for (String key in expenseType.keys) {
      singleSection = PieChartSectionData(
          title: '$key\n${expenseType[key]}%',
          titleStyle: TextStyle(color: Colors.black),
          radius: pixelsToDP(context, 200),
          color: Colors.blue[200],
          value: expenseType[key],
          titlePositionPercentageOffset: 1.4);
    }
    return singleSection;
  }

  List<Widget> createHistoryOfExpenses(expensesData, currency, context) {
    List<Widget> expensesHistory = [for (Map expenseType in expensesData) createHistorySingleRow(expenseType, currency, context)];
    return expensesHistory;
  }

  Widget createHistorySingleRow(expenseType, currency, context) {
    Widget singleRow;

    for (String key in expenseType.keys) {
      singleRow = Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey[50], width: pixelsToDP(context, 2))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(pixelsToDP(context, 10)),
                    margin: EdgeInsets.only(right: pixelsToDP(context, 10)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue[200]),
                    child: Text('${expenseType[key]}%')),
                Text(key)
              ],
            ),
            Text('${expenseType[key].toInt().toString()} $currency')
          ]));
    }
    return singleRow;
  }

  Widget build(BuildContext context) {
    final expensesBloc = ExpensesBlocProvider.of<ExpensesBloc>(context);

    return StreamBuilder(
        stream: expensesBloc.expensesStream,
        initialData: expensesBloc.expenses,
        builder: (context, snapshot) {
          var expensesData = snapshot.data;

          return SingleChildScrollView(
            child: Column(children: [
              Container(
                  constraints: BoxConstraints(maxHeight: pixelsToDP(context, 400), maxWidth: pixelsToDP(context, 400)),
                  child: PieChart(PieChartData(sections: createSections(expensesData, context)))),
              Container(
                  child: BlocBuilder(
                      bloc: context.read<SettingsBloc>(),
                      builder: (context, state) {
                        return Column(
                          children: createHistoryOfExpenses(expensesData, state.currency, context),
                        );
                      }))
            ]),
          );
        });
  }
}
