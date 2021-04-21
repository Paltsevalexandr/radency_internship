import 'package:flutter/material.dart';
import 'package:flutter_app/utils/ui_utils.dart';

Widget incomeText(context, String currency, double value) {
  return SizedBox(
    width: pixelsToDP(context, 250.0),
    child: Text(
      '$currency ${value.toStringAsFixed(2)}',
      style: const TextStyle(color: Colors.blue, fontSize: 18),
    ),
  );
}

Widget outcomeText(context, String currency, double value) {
  return Padding(
      padding: EdgeInsets.only(right: pixelsToDP(context, 24)),
      child: SizedBox(
        width: pixelsToDP(context, 250.0),
        child: Text(
          '$currency ${value.toStringAsFixed(2)}',
          textAlign: TextAlign.end,
          style: const TextStyle(color: Colors.redAccent, fontSize: 18),
        ),
      ));
}
