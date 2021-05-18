import 'package:uuid/uuid.dart';

abstract class Transaction {
  String id;
  TransactionType type;
  String accountOrigin;
  double amount;
  DateTime dateTime;
  String note;
  String currency;
  String subcurrency;

  Transaction({this.id, this.type, this.accountOrigin, this.amount, this.dateTime, this.note, this.currency, this.subcurrency});
}

enum TransactionType { Income, Expense, Transfer}
