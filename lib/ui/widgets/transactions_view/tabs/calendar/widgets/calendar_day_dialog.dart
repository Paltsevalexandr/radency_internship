import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/calendar_day.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/ui/widgets/daily_expenses_list.dart';

class CalendarDayDialog extends StatefulWidget {
  const CalendarDayDialog({Key key, @required this.day, @required this.currencySymbol}) : super(key: key);

  final CalendarDay day;
  final String currencySymbol;

  @override
  _CalendarDayDialogState createState() => _CalendarDayDialogState();
}

class _CalendarDayDialogState extends State<CalendarDayDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: min(MediaQuery.of(context).size.width * 0.8, 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _daySummary(widget.day),
              _transactionsList(widget.day.transactions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _daySummary(CalendarDay day) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is LoadedSettingsState) {
          return DailyExpensesHeader(
            dateTime: day.dateTime,
            incomeTotal: day.incomeAmount,
            outcomeTotal: day.expensesAmount,
          );
        }

        return SizedBox();
      },
    );
  }

  Widget _transactionsList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return SizedBox();
    } else {
      return Column(
        children: List.generate(
          transactions.length,
          (index) => Column(
            children: [Divider(), _transactionData(transactions[index])],
          ),
        ),
      );
    }
  }

  Widget _transactionData(Transaction transaction) {
    if (transaction is ExpenseTransaction) {
      return _transactionRow(
        children: [
          _expandedText(child: Text(transaction.category)),
          _expandedText(child: Text(transaction.accountOrigin)),
          _expandedText(
            child: Text(
              widget.currencySymbol + ' ' + transaction.amount.toStringAsFixed(2),
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    } else if (transaction is IncomeTransaction) {
      return _transactionRow(
        children: [
          // TODO: add income description
          _expandedText(child: Text('')),
          _expandedText(child: Text(transaction.accountOrigin)),
          _expandedText(
            child: Text(
              widget.currencySymbol + ' ' + transaction.amount.toStringAsFixed(2),
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    } else if (transaction is TransferTransaction) {
      return _transactionRow(
        children: [
          _expandedText(child: Text(S.current.transfer)),
          _expandedText(child: Text('${transaction.accountOrigin} \u{2192} ${transaction.accountDestination}')),
          _expandedText(
            child: Text(
              widget.currencySymbol + ' ' + transaction.amount.toStringAsFixed(2),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget _transactionRow({@required List<Widget> children}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
      constraints: BoxConstraints(maxWidth: min(MediaQuery.of(context).size.width * 0.7, 380)),
    );
  }

  Widget _expandedText({Text child}) {
    return Expanded(
      child: Container(child: child),
      flex: 1,
    );
  }
}
