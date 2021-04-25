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



TextStyle addTransactionFormTitleTextStyle(BuildContext context) {
  return TextStyle(color: Colors.grey, fontSize: 20);
}

TextStyle addTransactionBottomModalSheetButtonsTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).textTheme.bodyText1.color,
    fontSize: 18,
  );
}

TextStyle addTransactionElevatedButtonTitleStyle(BuildContext context, Color titleColor) {
  return TextStyle(color: titleColor, fontSize: 18);
}
