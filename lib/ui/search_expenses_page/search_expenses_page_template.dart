import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/accounts/account_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/search_transactions/search_transactions_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/ui/search_expenses_page/filters_view.dart';
import 'package:radency_internship_project_2/ui/search_expenses_page/summary_row_widget.dart';
import 'package:radency_internship_project_2/ui/search_expenses_page/transaction_widget.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class SearchExpensesPage extends StatefulWidget{
  @override
  _SearchExpensesPageState createState() => _SearchExpensesPageState();
}

class _SearchExpensesPageState extends State<SearchExpensesPage> {
  bool showFilters = true;

  @override
  void initState() {
    BlocProvider.of<SearchTransactionsBloc>(context).add(SearchTransactionsInitialize());
    BlocProvider.of<AccountBloc>(context).add(FetchAccounts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currency = BlocProvider.of<SettingsBloc>(context).state.currency;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text(S.current.searchExpensesSearchTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(),
            showFilters ? FiltersView() : Container(),
            ListTile(
              title: Icon(
                showFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
              ),
              onTap: (){
                setState(() {
                  showFilters = !showFilters;
                });
              },
            ),
            BlocBuilder<SearchTransactionsBloc, SearchTransactionsState>(
              builder: (context, state){
                if(state is SearchTransactionsLoading){
                  return CircularProgressIndicator();
                }

                if(state is SearchTransactionsLoaded){
                  double income = 0;
                  double outcome = 0;
                  double transfer = 0;

                  final transactions = state.transactions;
                  transactions.forEach((element) {
                    if(element is IncomeTransaction){
                      income += element.amount;
                    }
                    if(element is ExpenseTransaction){
                      outcome += element.amount;
                    }
                    if(element is TransferTransaction){
                      transfer += element.amount;
                      outcome += element.fees ?? 0;
                    }
                  });

                  return Column(
                    children: [
                      Divider(),
                      SummaryRowWidget(
                        income: income,
                        outcome: outcome,
                        transfer: transfer,
                        currency: currency,
                      ),
                      Divider(),
                    ] + transactions.map((e) => TransactionWidget(
                      transaction: e,
                    )).toList(),
                  );
                }

                return Container();
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: pixelsToDP(context, 60),
        vertical: pixelsToDP(context, 30),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5)
          )
        ),
      ),
    );
  }
}