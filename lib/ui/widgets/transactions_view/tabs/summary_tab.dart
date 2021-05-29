import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/export_csv/export_csv_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_summary/transactions_summary_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/summary_details.dart';
import 'package:radency_internship_project_2/ui/shared_components/centered_text_container.dart';
import 'package:radency_internship_project_2/ui/shared_components/elevated_buttons/colored_elevated_button.dart';
import 'package:radency_internship_project_2/ui/shared_components/empty_data_refresh_container.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/widgets/data_loading_widget.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class SummaryTab extends StatefulWidget {
  SummaryTab();

  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  @override
  Widget build(BuildContext context) {
    return _buildSummaryContent();
  }

  Widget _buildSummaryContent() {
    return BlocBuilder<TransactionsSummaryBloc, TransactionsSummaryState>(builder: (context, state) {
      if (state is TransactionsSummaryLoading) {
        return DataLoadingWidget();
      }

      if (state is TransactionsSummaryLoaded) {
        if (state.summaryDetails.accountsExpensesDetails.values.isEmpty &&
            state.summaryDetails.income == 0.0 &&
            state.summaryDetails.expenses == 0.0) {
          return EmptyDataRefreshContainer(
            message: S.current.noDataForCurrentDateRangeMessage,
            refreshCallback: () {
              context.read<TransactionsSummaryBloc>().add(TransactionsSummaryRefreshPressed());
            },
          );
        } else {
          return _content(state);
        }
      }

      return SizedBox();
    });
  }

  Widget _content(TransactionsSummaryLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TransactionsSummaryBloc>().add(TransactionsSummaryRefreshPressed());
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(),
            _buildRowContent(),
            Divider(),
            _buildAccounts(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: pixelsToDP(context, 60),
              ),
              child: BlocBuilder<CsvExportBloc, CsvExportState>(
                builder: (BuildContext context, csvState) {
                  var csvExportBloc = BlocProvider.of<CsvExportBloc>(context);
                  var data = MockedExpensesItems().generateDailyData();

                  return ColoredElevatedButton(
                      onPressed: () => csvExportBloc.add(ExportDataToCsv(data: data)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_moderator),
                          SizedBox(
                            width: pixelsToDP(context, 30),
                          ),
                          Text(S.current.transactionsTabButtonExportToCSV)
                        ],
                      ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRowContent() {
    return BlocBuilder<TransactionsSummaryBloc, TransactionsSummaryState>(builder: (context, state) {
      if (state is TransactionsSummaryLoaded) {
        String currency = context.read<SettingsBloc>().state.currency;

        return Row(
          children: [
            Expanded(
                child: _buildRowItem(
              title: S.current.income,
              currencySymbol: getCurrencySymbol(currency),
              amount: state.summaryDetails.income,
              color: Colors.blue,
            )),
            Expanded(
                child: _buildRowItem(
              title: S.current.expenses,
              currencySymbol: getCurrencySymbol(currency),
              amount: state.summaryDetails.expenses,
              color: Colors.red,
            )),
            Expanded(
                child: _buildRowItem(
              title: S.current.total,
              currencySymbol: getCurrencySymbol(currency),
              amount: state.summaryDetails.total,
            )),
          ],
        );
      }

      return SizedBox();
    });
  }

  Widget _buildAccounts() {
    return BlocBuilder<TransactionsSummaryBloc, TransactionsSummaryState>(builder: (context, state) {
      if (state is TransactionsSummaryLoaded) {
        if (state.summaryDetails.accountsExpensesDetails.values.isEmpty) {
          return CenteredTextContainer(text: S.current.noCategoriesExpensesDetailsMessage);
        } else {
          return Column(
            children: [
              _accountsTitle(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: pixelsToDP(context, 75),
                  vertical: pixelsToDP(context, 60),
                ),
                margin: EdgeInsets.all(pixelsToDP(context, 60)),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                child: _categoriesExpensesList(state.summaryDetails),
              ),
            ],
          );
        }
      }

      return SizedBox();
    });
  }

  Widget _accountsTitle() {
    return Container(
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
          Text(" ${S.current.transactionsTabTitleAccount}",
              style: TextStyle(fontSize: pixelsToDP(context, 54), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _categoriesExpensesList(SummaryDetails summaryDetails) {
    return Column(
      children: List.generate(
        summaryDetails.accountsExpensesDetails.length,
        (index) => Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  summaryDetails.accountsExpensesDetails.keys.elementAt(index),
                  style: regularTextStyle,
                )),
                Text(
                  summaryDetails.accountsExpensesDetails.values.elementAt(index).toStringAsFixed(2),
                  style: regularTextStyle,
                )
              ],
            ),
            if (index < summaryDetails.accountsExpensesDetails.length - 1)
              SizedBox(
                height: pixelsToDP(context, 30),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem({String title, String currencySymbol, double amount, Color color}) {
    return Column(
      children: [
        Text(title),
        SizedBox(
          height: pixelsToDP(context, 15),
        ),
        Text(
          amount.toStringAsFixed(2),
          style: expensesTabStyle(context).copyWith(color: color),
        ),
      ],
    );
  }
}
