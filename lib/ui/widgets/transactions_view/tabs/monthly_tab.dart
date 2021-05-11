import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/transactions/transactions_monthly/transactions_monthly_bloc.dart';
import '../../../../ui/widgets/transactions_view/widgets/data_loading_widget.dart';
import '../../monthly_expenses_list.dart';

class MonthlyTab extends StatefulWidget {
  MonthlyTab();

  @override
  _MonthlyTabState createState() => _MonthlyTabState();
}

class _MonthlyTabState extends State<MonthlyTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _monthlyContent()
    );
  }

  Widget _monthlyContent() {
    return BlocBuilder<TransactionsMonthlyBloc, TransactionsMonthlyState>(builder: (context, state) {
      if (state is TransactionsMonthlyLoading) {
        return DataLoadingWidget();
      }

      if (state is TransactionsMonthlyLoaded) {
        return buildMonthlyExpensesList(context);
      }

      return SizedBox();
    });
  }
}
