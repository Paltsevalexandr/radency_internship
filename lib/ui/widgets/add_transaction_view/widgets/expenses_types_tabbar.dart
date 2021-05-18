import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/add_transaction_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_expense_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_income_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_transfer_form.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class ExpensesTypesTabbar extends StatefulWidget{
  @override
  _ExpensesTypesTabbarState createState() => _ExpensesTypesTabbarState();
}

class _ExpensesTypesTabbarState extends State<ExpensesTypesTabbar> {
  TransactionType selectedTab = TransactionType.Income;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: TransactionType.values.map((element) {
            String buttonType = element == selectedTab ? "selected" : "simple";

            return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: pixelsToDP(context, 9),
              ),
              child: TextButton(
                style: getButtonStyleMap(context)[buttonType],
                child: Text(
                  getTransactionType(element.toString().split('.').last),
                  style: regularTextStyle.copyWith(
                    color: element == selectedTab ? Theme.of(context).accentColor : Colors.black54,
                  ),
                ),
                onPressed: (){
                  setState(() {
                    selectedTab = element;
                  });
                },
              ),
            ),
          );
          }).toList(),
        ),
        getTransactionForm(),
      ],
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
   backgroundColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.05)),
   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
     RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(pixelsToDP(context, 15)),
       side: BorderSide(
         color: Colors.black12,
         width: pixelsToDP(context, 3),
       )
     )
   ),
 ),
 "selected" : ButtonStyle(
   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
     RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(pixelsToDP(context, 15)),
       side: BorderSide(
         color: Theme.of(context).accentColor,
         width: pixelsToDP(context, 4.5),
       )
     )
   ),
 ),
};
