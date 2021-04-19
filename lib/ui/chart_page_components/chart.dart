import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../blocs/expenses/expenses_bloc.dart';

class Chart extends StatelessWidget {

  
  List<PieChartSectionData> createSections(chartData) {
    List<PieChartSectionData> chartSections = 
    [
      for(Map expenseType in chartData)
        for(String key in expenseType.keys)
          PieChartSectionData(
            title: '$key\n${expenseType[key]}%',
            titleStyle: TextStyle(color: Colors.black),
            radius: 100,
            color: Colors.blue,
            value: expenseType[key],
            titlePositionPercentageOffset: 1.4
          )
    ];
    return chartSections;
  }

  List<Widget> history(chartData) {
    List<Widget> expensesHistory = [
      for(Map expenseType in chartData)
        for(String key in expenseType.keys)
          Container(
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
                          color: Colors.blue
                        ),
                        child: Text('${expenseType[key]}%')
                      ),
                      Text(key)
                    ],
                ),
                Text(expenseType[key].toString())
              ]
          )
      )
    ];
    return expensesHistory;
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
              child: Column(
                children: history(expensesData),
            )
            )
          ]
        );
      }
    );
  }
}
