import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/expenses_types_tabbar.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  AddTransactionPageState createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage> {
  String pageTitle = S.current.income;

  setPageTitle(currentTab) {
    setState(() {
      switch(currentTab) {
        case TransactionType.Income:
          pageTitle = S.current.income;
          break;
        case TransactionType.Expense:
          pageTitle = S.current.expense;
          break;
        case TransactionType.Transfer:
          pageTitle = S.current.transfer;
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle, style: TextStyle(fontSize: 20,  fontFamily: 'OpenSans'),),
        centerTitle: true,
        toolbarHeight: 80,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onPressed: () => Navigator.of(context).pop(),
        ), 
      ),
      body: SingleChildScrollView(
        child: ExpensesTypesTabbar(setPageTitle),
      ),
    );
  }
}
