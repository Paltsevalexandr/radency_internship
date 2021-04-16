import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';

class Chart extends StatefulWidget {
  final List<Map<String, double>> chartData;

  Chart(this.chartData);

  ChartState createState() => ChartState(chartData);
}

class ChartState extends State<Chart> {
  final List<Map<String, double>> chartData;
  int touchedIndex;

  ChartState(this.chartData);
  
  List<PieChartSectionData> createSections() {
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

  List<Widget> history() {
    List<Widget> expensesHistory = [
      for(Map expenseType in chartData)
        for(String key in expenseType.keys)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: EdgeInsets.only(bottom: 10),
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
    return ListView(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
          child: PieChart(
            PieChartData(
              sections:createSections()
            ) 
          )
        ),
        Container(
          child: Column(
            children: history(),
         )
        )
      ]
    );
  }
}
