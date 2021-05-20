import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/models/expense_category.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class PieOutsideLabelChart extends StatelessWidget {
  final List<ExpenseCategory> expensesData;

  PieOutsideLabelChart({this.expensesData});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: charts.PieChart(
        createChartSections(),
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]),
        behaviors: [
          charts.DatumLegend(
            desiredMaxColumns: 2
          )
        ],
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width * 1.15, maxWidth: MediaQuery.of(context).size.width),
      margin: EdgeInsets.only(bottom: pixelsToDP(context, 100)));
  }
  List<charts.Series<ExpenseCategory, dynamic>> createChartSections() {
    return [
      charts.Series(
        data: expensesData,
        domainFn: (expense, _) => expense.expenseName,
        measureFn: (expense, _) => expense.percents,
        colorFn: (expense, _)  {
          var color = charts.Color(r: expense.color.r, g: expense.color.g, b: expense.color.b, a: 255);
          return charts.Color.fromOther(color: color);
        },
        id: "expense",
        labelAccessorFn: (expense, index) => '${expense.percents}',
      )
    ];
  }
}
