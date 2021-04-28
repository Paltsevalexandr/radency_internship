import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/expenses_types_tabbar.dart';

class AddTransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.addTransaction),
      ),
      body: SingleChildScrollView(
        child: ExpensesTypesTabbar(),
      ),
    );
  }
}
