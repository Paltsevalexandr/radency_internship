import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:uuid/uuid.dart';

class TransferTransaction extends Transaction {
  String accountOrigin;
  String accountDestination;
  double amount;
  DateTime dateTime;
  String note;
  String currency;
  String subcurrency;
  double fees;

  TransferTransaction({
    @required this.amount,
    @required this.dateTime,
    @required this.note,
    @required this.fees,
    @required this.accountOrigin,
    @required this.accountDestination,
    @required this.currency,
    this.subcurrency,
  }) : super(
    id: Uuid().v1(),
    type: TransactionType.Transfer,
    accountOrigin: accountOrigin,
    amount: amount,
    dateTime: dateTime,
    note: note,
    currency: currency,
    subcurrency: subcurrency,
  );
}
