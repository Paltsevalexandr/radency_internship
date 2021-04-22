import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/transactions/transactions_daily/transactions_daily_bloc.dart';
import '../../../../ui/widgets/transactions_view/widgets/data_loading_widget.dart';
import '../../../../ui/widgets/transactions_view/widgets/transactions_data_placeholder.dart';

class DailyTab extends StatefulWidget {
  DailyTab();

  @override
  _DailyTabState createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dailyContent(),
          ],
        ),
      ),
    );
  }

  Widget _dailyContent() {
    return BlocBuilder<TransactionsDailyBloc, TransactionsDailyState>(builder: (context, state) {
      if (state is TransactionsDailyLoading) return DataLoadingWidget();

      if (state is TransactionsDailyLoaded) return TransactionsDataPlaceholder(text: state.sliderCurrentTimeIntervalString);

      return SizedBox();
    });
  }
}
