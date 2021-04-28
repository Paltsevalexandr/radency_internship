import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';

class ExpenseTransaction implements Transaction {
  double amount;
  DateTime dateTime;
  String note;
  String account;
  String category;
  FullContact sharedContact;

  ExpenseTransaction({@required this.dateTime, @required this.account, @required this.category, @required this.amount, @required this.note, this.sharedContact});
}
