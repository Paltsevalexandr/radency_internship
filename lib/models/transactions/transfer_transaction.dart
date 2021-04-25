import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:meta/meta.dart';

class TransferTransaction implements Transaction {
  double amount;
  DateTime dateTime;
  String note;
  String from;
  String to;
  double fees;

  TransferTransaction({
    @required this.amount,
    @required this.dateTime,
    @required this.note,
    @required this.fees,
    @required this.from,
    @required this.to,
  });
}
