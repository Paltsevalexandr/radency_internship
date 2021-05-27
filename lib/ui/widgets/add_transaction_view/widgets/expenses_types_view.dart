import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/add_transaction_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/transaction_type/transaction_type_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_expense_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_income_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_transfer_form.dart';

class ExpensesTypesTabbar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionTypeBloc, TransactionTypeState>(
      builder: (context, state) {
        return getTransactionForm(state.selectedType);
      }
    );
  }

  Widget getTransactionForm(TransactionType selectedTab) {
    switch (selectedTab) {
      case TransactionType.Income:
        return BlocProvider<AddTransactionBloc>(
          create: (_) => AddTransactionBloc()..add(AddTransactionInitialize()),
          child: AddIncomeForm(),
        );
        break;
      case TransactionType.Transfer:
        return BlocProvider<AddTransactionBloc>(
          create: (_) => AddTransactionBloc()..add(AddTransactionInitialize()),
          child: AddTransferForm(),
        );
        break;
      case TransactionType.Expense:
        return BlocProvider<AddTransactionBloc>(
          create: (_) => AddTransactionBloc()..add(AddTransactionInitialize()),
          child: AddExpenseForm(),
        );
        break;
      default:
        return SizedBox();
    }
  }
}

String getTransactionType(String type){
  String result = '';
  switch(type){
    case 'Income':
      result = S.current.income;
      break;
    case 'Expense':
      result = S.current.expense;
      break;
    case 'Transfer':
      result = S.current.transfer;
      break;
  }

  return result;
}
