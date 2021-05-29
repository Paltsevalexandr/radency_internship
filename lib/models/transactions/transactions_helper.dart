import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/utils/strings.dart';

class TransactionsHelper {
  Map<String, dynamic> convertTransactionToJson({@required Transaction transaction}) {
    Map<String, dynamic> transactionMap;

    switch (transaction.transactionType) {
      case TransactionType.Income:
        transactionMap = (transaction as IncomeTransaction).toJson();
        break;
      case TransactionType.Expense:
        transactionMap = (transaction as ExpenseTransaction).toJson();
        break;
      case TransactionType.Transfer:
        transactionMap = (transaction as TransferTransaction).toJson();
        break;
    }

    return transactionMap;
  }

  Transaction convertJsonToTransaction({@required Map<String, dynamic> json, @required String key}) {
    Transaction transaction;

    TransactionType transactionType = enumFromString<TransactionType>(TransactionType.values, json[TYPE_KEY]);

    switch (transactionType) {
      case TransactionType.Income:
        transaction = IncomeTransaction.fromJson(json, key);
        break;
      case TransactionType.Expense:
        transaction = ExpenseTransaction.fromJson(json, key);
        break;
      case TransactionType.Transfer:
        transaction = TransferTransaction.fromJson(json, key);
        break;
    }

    return transaction;
  }
}
