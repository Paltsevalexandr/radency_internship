import 'package:flutter/material.dart';
import '../../utils/ui_utils.dart';

Widget buildIncomeText(context, String currency, double value) {
  return Wrap(
    children: [
      Text(
        '$currency ${value.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.blue, fontSize: 18),
      ),
    ],
  );
}

Widget buildOutcomeText(context, String currency, double value) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: pixelsToDP(context, 24)),
      child: Wrap(
        children: [
          Text(
            '$currency ${value.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.redAccent, fontSize: 18),
          ),
        ],
      ));
}
