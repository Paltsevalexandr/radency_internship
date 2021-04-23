import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/add_transaction_bloc.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_expense_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_transfer_form.dart';

enum TransactionType { income, transfer, expense }

class AddTransactionView extends StatefulWidget {
  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  TransactionType transactionType = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add transaction'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: List.generate(
                  TransactionType.values.length,
                  (index) => TextButton(
                      onPressed: () {
                        setState(() {
                          transactionType = TransactionType.values[index];
                        });
                      },
                      child: Text(TransactionType.values[index].toString().split('.').last))),
            ),
            getTransactionForm(),
          ],
        ),
      ),
    );
  }

  Widget getTransactionForm() {
    switch (transactionType) {
      case TransactionType.income:
        return SizedBox();
        break;
      case TransactionType.transfer:
        return BlocProvider<AddTransactionBloc>(
          create: (_) => AddTransactionBloc()..add(AddExpenseInitialize()),
          child: AddTransferForm(),
        );
        break;
      case TransactionType.expense:
        return BlocProvider<AddTransactionBloc>(
          create: (_) => AddTransactionBloc()..add(AddExpenseInitialize()),
          child: AddExpenseForm(),
        );
        break;
      default:
        return SizedBox();
    }
  }
}
