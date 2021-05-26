import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class TransactionWidget extends StatelessWidget{
  final Transaction transaction;

  const TransactionWidget({Key key, this.transaction}) : super(key: key);

  Widget build(BuildContext context) {
    String currency = BlocProvider.of<SettingsBloc>(context).state.currency;

    Color valueColor = null;
    String subLabel = "";
    String accountLabel = "";

    if(transaction is TransferTransaction){
      subLabel = "Transfer";
      accountLabel = transaction.accountOrigin + " –> " + (transaction as TransferTransaction).accountDestination;
    }
    if(transaction is ExpenseTransaction){
      subLabel = (transaction as ExpenseTransaction).category;
      accountLabel = transaction.accountOrigin;
      valueColor = Colors.red;
    }
    if(transaction is IncomeTransaction){
      accountLabel = transaction.accountOrigin;
      subLabel = (transaction as IncomeTransaction).category;
      valueColor = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: pixelsToDP(context, 80),
        left: pixelsToDP(context, 30),
        right: pixelsToDP(context, 30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(DateFormatters().dateToString(transaction.dateTime)),
                SizedBox(
                  height: pixelsToDP(context, 10),
                ),
                Text(subLabel),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              accountLabel,
              style: regularTextStyle,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "${getCurrencySymbol(currency)} ${getMoneyFormatted(transaction.amount)}",
                  style: regularTextStyle.copyWith(
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}