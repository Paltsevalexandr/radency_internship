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

  List<String> toStringInList(Transaction transaction) {
    checkValueType(value) {
      if(value == null || value == 'null') {
        return '';

      } else if(value is String != true) {
        return value.toString();

      } else {
        return value;
      }
    }
    Map transactionToMap = convertTransactionToJson(transaction: transaction);
    List transactionToList = [
      checkValueType(transactionToMap['transactionType']),
      checkValueType(transactionToMap['amount']),
      checkValueType(transactionToMap['date']),
      checkValueType(transactionToMap['creationDate']),
      checkValueType(transactionToMap['accountOrigin']),
      checkValueType(transactionToMap['category']),
      checkValueType(transactionToMap['note']),
      checkValueType(transactionToMap['currency']),
      checkValueType(transactionToMap['subcurrency']),
      checkValueType(transactionToMap['accountDestination']),
      checkValueType(transactionToMap['fees']),
      checkValueType(transactionToMap['locationLatitude']),
      checkValueType(transactionToMap['locationLongitude']),
      checkValueType(transactionToMap['sharedContact']),
      checkValueType(transactionToMap['creationType']),
    ];
    String transactionToString = transactionToList.join(";");
    return [transactionToString];
  }
  
  Transaction fromStringInList(List transaction) {
    checkValue(value) {
      if(value == '') {
        return null;
      } else {
        var valueToNum = num.tryParse(value);
        if(valueToNum != null) return valueToNum;
        else return value;
      }
    }
    String stringTransaction = transaction[0];
    List<String> transactionToList = stringTransaction.split(";");
    Map<String, dynamic> transactionToMap = {
      'transactionType': checkValue(transactionToList[0]),
      'amount': checkValue(transactionToList[1]),
      'date': checkValue(transactionToList[2]),
      'creationDate': checkValue(transactionToList[3]),
      'accountOrigin': checkValue(transactionToList[4]),
      'category': checkValue(transactionToList[5]),
      'note': transactionToList[6],
      'currency': checkValue(transactionToList[7]),
      'subcurrency': checkValue(transactionToList[8]),
      'accountDestination': checkValue(transactionToList[9]),
      'fees': checkValue(transactionToList[10]),
      'locationLatitude': checkValue(transactionToList[11]),
      'locationLongitude': checkValue(transactionToList[12]),
      'sharedContact': checkValue(transactionToList[13]),
      'creationType': checkValue(transactionToList[14]),
    };
    print(transactionToMap['note'] == null);
    Transaction transactionEntity = convertJsonToTransaction(json: transactionToMap, key: transactionToMap['id']);
    return transactionEntity;
  }
}
