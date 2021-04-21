import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/expenses/expenses_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';

class Chart extends StatelessWidget {
  
  List<PieChartSectionData> createSections(expensesData) {

    List<PieChartSectionData> chartSections = 
    [
      for(Map expenseType in expensesData)
        createSingleChartSection(expenseType)
    ];
    return chartSections;
  }

  PieChartSectionData createSingleChartSection(Map expenseType) {
    PieChartSectionData singleSection;

    for(String key in expenseType.keys) {
      singleSection = PieChartSectionData(
        title: '$key\n${expenseType[key]}%',
        titleStyle: TextStyle(color: Colors.black),
        radius: 100,
        color: Colors.blue[200],
        value: expenseType[key],
        titlePositionPercentageOffset: 1.4
      );
    }
    return singleSection;
  }

  List<Widget> createHistoryOfExpenses(expensesData, currency) {
    
    List<Widget> expensesHistory = [
      for(Map expenseType in expensesData)
        createHistorySingleRow(expenseType, currency)
    ];
    return expensesHistory;
  }

  Widget createHistorySingleRow(expenseType, currency) {
    Widget singleRow;

    for(String key in expenseType.keys) {
      singleRow = Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey[50], width: 1)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue[200]
                  ),
                  child: Text('${expenseType[key]}%')
                ),
                Text(key)
              ],
            ),
            Text('${expenseType[key].toInt().toString()} $currency')
          ]
        )
      );
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

        return ListView(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
              child: PieChart(
                PieChartData(
                  sections: createSections(expensesData)
                )
              ) 
            ),
            Container(
              child: BlocBuilder(
                bloc: context.read<SettingsBloc>(),
                builder: (context, state) {
                  return Column(
                    children: createHistoryOfExpenses(expensesData, state.currency),
                  );
                }
              )
            )
          ]
        );
      }
    );
  }
}
