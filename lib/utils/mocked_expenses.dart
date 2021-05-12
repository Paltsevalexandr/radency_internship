import 'dart:math';

import 'package:radency_internship_project_2/models/budget/monthly_category_expense.dart';
import 'package:radency_internship_project_2/models/location.dart';


import '../models/expense_item.dart';

class MockedExpensesItems {
  final List<String> categories = [
    'Food',
    'Social life',
    'Self-development',
    'Culture',
    'Household',
    'Apparel',
    'Beauty',
    'Health',
    'Transportation',
    'Education',
    'Gift',
  ];
  final List<String> accounts = ['Cash', 'Bank accounts', 'Credit cards'];

  Map<int, List<ExpenseItemEntity>> generateDailyData({double locationLatitude, double locationLongitude}) {
    var map = Map<int, List<ExpenseItemEntity>>();

    var list = List<ExpenseItemEntity>.empty(growable: true);

    for (int j = 1; j < 100; j++) {
      var date = Random().nextInt(29) + 1;
      var dateString = date <= 9 ? "0$date" : date.toString();

      double newLatitude = 0;
      double newLongitude = 0;

      if (locationLatitude != null && locationLongitude != null) {
        newLatitude = locationLatitude + (Random().nextInt(9) * 0.01);
        newLongitude = locationLongitude + (Random().nextInt(9) * 0.01);
      }

      ExpenseLocation expenseLocation = ExpenseLocation(address: '', latitude: newLatitude, longitude: newLongitude);

      list.add(ExpenseItemEntity(j, j % 2 == 0 ? ExpenseType.income : ExpenseType.outcome, 5 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j),
          DateTime.parse("2021-04-$dateString"), "Catname", "Description $j", expenseLocation: expenseLocation));
    }

    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    var currentDay = 0;
    var currentList = List<ExpenseItemEntity>.empty(growable: true);

    list.forEach((element) {
      var itemDay = element.dateTime.day;

      if (currentDay == 0) {
        currentDay = itemDay;
      }

      if (currentDay != itemDay || list.last == element) {
        map[currentDay] = currentList.toList();
        currentDay = itemDay;
        currentList.clear();
      }

      currentList.add(element);
    });

    return map;
  }

  List<ExpenseWeeklyItemEntity> generateWeeklyData() {
    var list = List<ExpenseWeeklyItemEntity>.empty(growable: true);

    for (int j = 1; j < 20; j++) {
      var date = Random().nextInt(10) + 1;

      list.add(ExpenseWeeklyItemEntity(j, 1 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j), 3 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j), date));
    }

    list.sort((a, b) => a.weekNumber.compareTo(b.weekNumber));

    return list;
  }

  List<ExpenseMonthlyItemEntity> generateMonthlyData() {
    var list = List<ExpenseMonthlyItemEntity>.empty(growable: true);

    for (int j = 1; j < 20; j++) {
      var month = Random().nextInt(12) + 1;

      list.add(ExpenseMonthlyItemEntity(j, 1 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j), 3 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j), month));
    }

    list.sort((a, b) => a.monthNumber.compareTo(b.monthNumber));

    return list;
  }

  ExpenseSummaryItemEntity generateSummaryData() {
    double income = 100 * sqrt(Random().nextInt(100) + 1);
    double outcomeCash = 100 * sqrt(Random().nextInt(25) + 1);
    double outcomeCreditCards = 100 * sqrt(Random().nextInt(25) + 1);

    return ExpenseSummaryItemEntity(1, income, outcomeCash, outcomeCreditCards);
  }

  Future<List<MonthlyCategoryExpense>> generateMonthlyCategoryExpenses() async {
    List<MonthlyCategoryExpense> list = [];

    categories.forEach((category) {
      bool expensesAvailable = Random().nextBool();
      list.add(MonthlyCategoryExpense(category: category, expenseAmount: expensesAvailable ? Random().nextDouble() * Random().nextInt(1000) : 0.0));
    });

    await Future.delayed(Duration(seconds: 1));
    return list;
  }

  List<Map<String, double>> summaryExpensesByCategories() {
    List<Map<String, double>> expensesByCategories = [];

    for(String category in categories) {
      double categorySum = (Random().nextDouble() * Random().nextInt(1000));
      double roundedCategorySum = num.parse(categorySum.toInt().toStringAsFixed(2));
      expensesByCategories.add({category: roundedCategorySum});
    }
    return expensesByCategories;
  }
}
