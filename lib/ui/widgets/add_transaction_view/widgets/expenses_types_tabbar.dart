import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/add_transaction_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_expense_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_income_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_transfer_form.dart';

class ExpensesTypesTabbar extends StatefulWidget{
  ExpensesTypesTabbar(this.setPageTitle);

  final Function setPageTitle;

  @override
  _ExpensesTypesTabbarState createState() => _ExpensesTypesTabbarState(setPageTitle);
}

class _ExpensesTypesTabbarState extends State<ExpensesTypesTabbar> {
  _ExpensesTypesTabbarState(this.setPageTitle);

  TransactionType selectedTab = TransactionType.Income;
  Function setPageTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).accentColor),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Row(
            children: TransactionType.values.map((element) {
              String buttonType = element == selectedTab ? "selected" : "simple";

              return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: TextButton(
                  style: getButtonStyleMap(context)[buttonType],
                  child: Text(
                    getTransactionType(element.toString().split('.').last),
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontFamily: 'OpenSans', 
                      fontSize: 14),
                  ),
                  onPressed: (){
                    setPageTitle(element);
                    setState(() {
                      selectedTab = element;
                    });
                  },
                ),
              ),
            );
            }).toList(),
          )),
          Container(
            color: Theme.of(context).accentColor,
            child: getTransactionForm()
          ),
        ],
      )
    );
  }

  Widget getTransactionForm() {
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

getButtonStyleMap(BuildContext context) => {
 "simple" : ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 22)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shadowColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
 ),
 "selected" : ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 22)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.4)),
    shadowColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor.withOpacity(0.4)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )
    ),
  ),
};
