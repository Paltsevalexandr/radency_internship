import 'dart:math';

import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';

class MockedCalendarData {
  List<Transaction> generateMonthlyTransactions({@required DateTime dateTime}) {
    List<Transaction> list = [];

    int currentMonth = dateTime.month;
    DateTime observedDay = DateTime(dateTime.year, dateTime.month, 1);

    do {
      if (Random().nextInt(10) > 8) {
        list.add(IncomeTransaction(
          accountOrigin: MockedExpensesItems().accounts[Random().nextInt(MockedExpensesItems().accounts.length)],
          amount: Random().nextInt(10000).toDouble() + 1000,
          dateTime: observedDay,
          currency: 'UAH',
          category: 'Food',
          note: '',
        ));
      }

      int expensesQuantity = Random().nextInt(4);

      for (int i = 0; i < expensesQuantity; i++) {
        list.add(ExpenseTransaction(
            dateTime: observedDay,
            accountOrigin: MockedExpensesItems().accounts[Random().nextInt(MockedExpensesItems().accounts.length)],
            category: MockedExpensesItems().categories[Random().nextInt(MockedExpensesItems().categories.length)],
            amount: Random().nextInt(1000).toDouble(),
            note: '',
            currency: 'UAH'));
      }

      if (Random().nextInt(10) > 8) {
        list.add(TransferTransaction(
          amount: Random().nextInt(4000).toDouble() + 1000,
          dateTime: observedDay,
          accountOrigin: MockedExpensesItems().accounts[Random().nextInt(MockedExpensesItems().accounts.length)],
          accountDestination: MockedExpensesItems().accounts[Random().nextInt(MockedExpensesItems().accounts.length)],
          fees: 10.0,
          note: '',
          currency: 'UAH',
        ));
      }

      observedDay = DateTime(observedDay.year, observedDay.month, observedDay.day + 1);
    } while (observedDay.month == currentMonth);

    return list;
  }
}
