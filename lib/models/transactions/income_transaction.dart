import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:uuid/uuid.dart';

class IncomeTransaction extends Transaction {
  String category;
  String accountOrigin;
  double amount;
  DateTime dateTime;
  String note;
  String currency;
  String subcurrency;

  IncomeTransaction({
    @required this.dateTime,
    @required this.accountOrigin,
    @required this.category,
    @required this.amount,
    @required this.note,
    @required this.currency,
    this.subcurrency
  }) : super(
    id: Uuid().v1(),
    type: TransactionType.Expense,
    accountOrigin: accountOrigin,
    amount: amount,
    dateTime: dateTime,
    note: note,
    currency: currency,
    subcurrency: subcurrency,
  );
}
