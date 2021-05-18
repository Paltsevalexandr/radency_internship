import 'package:flutter/material.dart';

Widget buildIncomeText(context, String currency, double value) {
  return Text(
    '$currency ${value.toStringAsFixed(2)}',
    style: const TextStyle(color: Colors.blue, fontSize: 18),
  );
}

Widget buildOutcomeText(context, String currency, double value) {
  return Text(
    '$currency ${value.toStringAsFixed(2)}',
    textAlign: TextAlign.end,
    style: const TextStyle(color: Colors.redAccent, fontSize: 18),
  );
}
