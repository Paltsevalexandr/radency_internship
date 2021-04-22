import 'package:flutter/material.dart';

TextStyle transactionsTabTitleStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).textTheme.bodyText1.color);
}

TextStyle expensesTabStyle(BuildContext context) {
  return TextStyle(
    fontSize: Theme.of(context).textTheme.bodyText1.fontSize + 2,
    fontWeight: FontWeight.w600
  );
}

const regularTextStyle = TextStyle(
  fontSize: 16,
);

