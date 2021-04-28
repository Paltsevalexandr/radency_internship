import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_summary/transactions_summary_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/expense_item.dart';
import 'package:radency_internship_project_2/utils/styles.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class SummaryTab extends StatefulWidget {
  SummaryTab();

  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent() {
    return BlocBuilder<TransactionsSummaryBloc, TransactionsSummaryState>(builder: (context, state) {
      if (state is TransactionsSummaryLoading)
        return Center(
          child: Padding(
            padding: EdgeInsets.all(pixelsToDP(context, 24)),
            child: CircularProgressIndicator(),
          ),
        );

      if (state is TransactionsSummaryLoaded)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(),
            _buildRowContent(),
            Divider(),
            Container(
              padding: EdgeInsets.only(
                left: pixelsToDP(context, 60),
                right: pixelsToDP(context, 60),
                top: pixelsToDP(context, 30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.money,
                  ),
                  Text(
                    " ${S.current.transactionsTabTitleAccount}",
                    style: TextStyle(
                      fontSize: pixelsToDP(context, 54),
                      fontWeight: FontWeight.w500
                    )
                  ),
                ],
              ),
            ),
            _buildAccounts(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: pixelsToDP(context, 60),
              ),
              child: ElevatedButton.icon(
                onPressed: (){},
                icon: Icon(Icons.add_moderator),
                label: Text(S.current.transactionsTabButtonExportToExcel),
              ),
            )
          ],
        );

      return SizedBox();
    });
  }

  Widget _buildRowContent(){
    return BlocBuilder<TransactionsSummaryBloc, TransactionsSummaryState>(builder: (context, state) {
      if (state is TransactionsSummaryLoaded) {
        ExpenseSummaryItemEntity expenseSummaryItemEntity = state.expenseSummaryItemEntity;
        String currency = context.read<SettingsBloc>().state.currency;

        return Row(
          children: [
            Expanded(
              child: _buildRowItem(
                title: S.current.income,
                currencySymbol: getCurrencySymbol(currency),
                amount: expenseSummaryItemEntity.income,
                color: Colors.blue,
              )
            ),
            Expanded(
              child: _buildRowItem(
                title: S.current.expenses,
                currencySymbol: getCurrencySymbol(currency),
                amount: expenseSummaryItemEntity.outcomeCash + expenseSummaryItemEntity.outcomeCreditCards,
                color: Colors.red,
              )
            ),
            Expanded(
              child: _buildRowItem(
                title: S.current.total,
                currencySymbol: getCurrencySymbol(currency),
                amount: expenseSummaryItemEntity.income - expenseSummaryItemEntity.outcomeCreditCards - expenseSummaryItemEntity.outcomeCash,
              )
            ),
          ],
        );
      }

      return SizedBox();
    });
  }

  Widget _buildAccounts(){
    return BlocBuilder<TransactionsSummaryBloc, TransactionsSummaryState>(builder: (context, state) {
      if (state is TransactionsSummaryLoaded) {
        ExpenseSummaryItemEntity expenseSummaryItemEntity = state.expenseSummaryItemEntity;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: pixelsToDP(context, 75),
            vertical: pixelsToDP(context, 60),
          ),
          margin: EdgeInsets.all(pixelsToDP(context, 60)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.transactionsTabButtonExpensesCashAccounts,
                      style: regularTextStyle,
                    )
                  ),
                  Text(
                    getMoneyFormatted(expenseSummaryItemEntity.outcomeCash, separator: " ", comma: "."),
                    style: regularTextStyle,
                  )
                ],
              ),
              SizedBox(
                height: pixelsToDP(context, 30),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.transactionsTabButtonExpensesCreditCards,
                      style: regularTextStyle,
                    )
                  ),
                  Text(
                    getMoneyFormatted(expenseSummaryItemEntity.outcomeCreditCards, separator: " ", comma: "."),
                    style: regularTextStyle,
                  )
                ],
              ),
            ],
          ),
        );
      }

      return SizedBox();
    });
  }

  Widget _buildRowItem({String title, String currencySymbol, double amount, Color color}){
    return Column(
      children: [
        Text(title),
        SizedBox(
          height: pixelsToDP(context, 15),
        ),
        Text(
          "$currencySymbol " + getMoneyFormatted(amount, separator: " ", comma: "."),
          style: expensesTabStyle(context).copyWith(color: color),
        ),
      ],
    );
  }
}
