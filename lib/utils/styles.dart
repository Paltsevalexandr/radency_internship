import 'package:flutter/material.dart';

TextStyle tabTitleStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).textTheme.bodyText1.color);
}

TextStyle expensesTabStyle(BuildContext context) {
  return TextStyle(fontSize: Theme.of(context).textTheme.bodyText1.fontSize + 2, fontWeight: FontWeight.w600);
}

const regularTextStyle = TextStyle(
  fontSize: 16,
);

const addTransactionAvatarTextStyle = TextStyle(
  fontSize: 28,
);

var primaryColorsArray = [
  "#FFFFFF", "#E25F4E", "#EB839A", "#5ABC7B", "#4896F4", "#4A4A4A"
];

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

ThemeMode getThemeMode(pMode) {
  if (pMode == "light") {
    return ThemeMode.light;
  } else if (pMode == 'dark') {
    return ThemeMode.dark;
  } else {
    return ThemeMode.system;
  }
}

class Styles {
  static Color getAccentColor(bool darkTheme, String primaryLightColor) {
    return darkTheme ? HexColor(primaryLightColor) : primaryLightColor == "#FFFFFF" ? Colors.blue : HexColor(primaryLightColor);
  }

  static ThemeData themeData(BuildContext context, bool darkTheme, String primaryLightColor) {
    return ThemeData(
      primaryColor: darkTheme ? Colors.black : HexColor(primaryLightColor),
      accentColor: getAccentColor(darkTheme, primaryLightColor),
      accentColorBrightness: darkTheme ? Brightness.dark : Brightness.light,
      backgroundColor: darkTheme ? Colors.black : HexColor("#F1F5FB"),
      cardColor: darkTheme ? HexColor("#151515") : Colors.white,
      canvasColor: darkTheme ? Colors.black : Colors.white,
      brightness: darkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: darkTheme ? ColorScheme.dark() : ColorScheme.light()),
    );
  }
}
// Budget view
// ###
const budgetItemUnlimitedTitleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const budgetItemUnlimitedExpenseAmountStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const budgetItemLimitedAndRemainingTitleStyle = TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold);
const budgetItemLimitedTotalBudgetAmountStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

TextStyle budgetItemLimitedExpenseAmountStyle({@required bool isOverBudget}) {
  return TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isOverBudget ? Colors.red : Colors.blue);
}

const budgetSummaryRemainingAmountStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


// ###
//

TextStyle elevatedButtonTitleStyle(BuildContext context, Color titleColor) {
  return TextStyle(color: titleColor, fontSize: 18);
}

TextStyle addTransactionFormTitleTextStyle(BuildContext context) {
  return TextStyle(color: Colors.grey, fontSize: 20);
}

TextStyle addTransactionBottomModalSheetButtonsTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).textTheme.bodyText1.color,
    fontSize: 18,
  );
}

TextStyle addTransactionElevatedButtonTitleStyle(BuildContext context, [Color titleColor]) {
  return TextStyle(color: titleColor, fontSize: 18);
}

InputDecoration addTransactionFormFieldDecoration({String hintText}) {
  return InputDecoration(
    helperText: '',
    hintText: hintText,
  );
}

// Search transactions view
// ###

TextStyle searchModalTitleStyle(BuildContext context) {
  return TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600
  );
}

TextStyle buttonTitleStyle(BuildContext context, [Color titleColor]) {
  return TextStyle(color: titleColor ?? Colors.black, fontSize: 18);
}