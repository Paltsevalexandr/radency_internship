import 'package:flutter/material.dart';
import '../chart/chart.dart';

class ChartPage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chart')
      ),
      body: Container(
        alignment: Alignment.center,
        child: Chart([{'Household': 20.0}, {'Hobby': 70.0}, {'Shopping': 10.0}])
      )
    );
  }
}