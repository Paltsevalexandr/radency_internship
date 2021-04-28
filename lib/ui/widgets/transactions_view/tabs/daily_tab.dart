import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/transactions/transactions_daily/transactions_daily_bloc.dart';
import '../../../../ui/widgets/transactions_view/widgets/data_loading_widget.dart';
import '../../daily_expenses_list.dart';

class DailyTab extends StatefulWidget {
  DailyTab();

  @override
  _DailyTabState createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _dailyContent()
    );
  }

  Widget _dailyContent() {
    return BlocBuilder<TransactionsDailyBloc, TransactionsDailyState>(builder: (context, state) {
      if (state is TransactionsDailyLoading) return DataLoadingWidget();

      if (state is TransactionsDailyLoaded) return buildDailyExpensesList(context);

      return SizedBox();
    });
  }
}
