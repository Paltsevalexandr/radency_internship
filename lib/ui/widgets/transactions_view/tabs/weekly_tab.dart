import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/transactions/transactions_weekly/transactions_weekly_bloc.dart';
import '../../../../ui/widgets/transactions_view/widgets/data_loading_widget.dart';
import '../../../../ui/widgets/transactions_view/widgets/transactions_data_placeholder.dart';

class WeeklyTab extends StatefulWidget {
  WeeklyTab();

  @override
  _WeeklyTabState createState() => _WeeklyTabState();
}

class _WeeklyTabState extends State<WeeklyTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_weeklyContent()],
        ),
      ),
    );
  }

  Widget _weeklyContent() {
    return BlocBuilder<TransactionsWeeklyBloc, TransactionsWeeklyState>(builder: (context, state) {
      if (state is TransactionsWeeklyLoading) return DataLoadingWidget();

      if (state is TransactionsWeeklyLoaded) return TransactionsDataPlaceholder(text: state.sliderCurrentTimeIntervalString);

      return SizedBox();
    });
  }
}
