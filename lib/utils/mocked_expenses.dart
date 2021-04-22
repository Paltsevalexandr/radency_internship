import 'dart:math';

import '../models/expense_item.dart';


class MockedExpensesItems {
  Map<int, List<ExpenseItemEntity>> generateDailyData() {
    var map = Map<int, List<ExpenseItemEntity>>();

    var list = List<ExpenseItemEntity>.empty(growable: true);

    for (int j = 1; j < 100; j++) {
      var date = Random().nextInt(29) + 1;
      var dateString = date <= 9 ? "0$date" : date.toString();

      list.add(ExpenseItemEntity(
          j,
          j % 2 == 0 ? ExpenseType.income : ExpenseType.outcome,
          5 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j),
          DateTime.parse("2021-04-$dateString"),
          "Catname",
          "Description $j"));
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

      list.add(ExpenseWeeklyItemEntity(
          j,
          1 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j),
          3 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j),
          date));
    }

    list.sort((a, b) => a.weekNumber.compareTo(b.weekNumber));

    return list;
  }

  List<ExpenseMonthlyItemEntity> generateMonthlyData() {
    var list = List<ExpenseMonthlyItemEntity>.empty(growable: true);

    for (int j = 1; j < 20; j++) {
      var month = Random().nextInt(12) + 1;

      list.add(ExpenseMonthlyItemEntity(
          j,
          1 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j),
          3 * sqrt(j) * j - sqrt(j) * j + j + sqrt(j),
          month));
    }

    list.sort((a, b) => a.month.compareTo(b.month));

    return list;
  }
}
