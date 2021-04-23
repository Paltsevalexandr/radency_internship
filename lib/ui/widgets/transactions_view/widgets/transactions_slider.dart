import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/transactions/transactions_daily/transactions_daily_bloc.dart';
import '../../../../blocs/transactions/transactions_monthly/transactions_monthly_bloc.dart';
import '../../../../blocs/transactions/transactions_slider/transactions_slider_bloc.dart';
import '../../../../blocs/transactions/transactions_weekly/transactions_weekly_bloc.dart';
import '../../../../ui/widgets/transactions_view/widgets/slider.dart';
import '../../../../blocs/transactions/transactions_summary/transactions_summary_bloc.dart';


class TransactionsTabSlider extends StatefulWidget {
  TransactionsTabSlider();

  @override
  _TransactionsTabSliderState createState() => _TransactionsTabSliderState();
}

class _TransactionsTabSliderState extends State<TransactionsTabSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsSliderBloc, TransactionsSliderState>(builder: (context, state) {
      if (state is TransactionsSliderLoaded) {
        switch (state.transactionsSliderMode) {
          case TransactionsSliderMode.daily:
            return Center(child: _dailySlider(context));
            break;
          case TransactionsSliderMode.weekly:
            return Center(child: _weeklySlider(context));
            break;
          case TransactionsSliderMode.monthly:
            return Center(child: _monthlySlider(context));
            break;
          case TransactionsSliderMode.summary:
            return Center(child: _summarySlider(context));
            break;
          case TransactionsSliderMode.undefined:
            return SizedBox();
            break;
        }
      }

      return SizedBox();
    });
  }
}

Widget _dailySlider(BuildContext context) {
  Function onDailyTransactionsBackPressed = () {
    return context.read<TransactionsDailyBloc>().add(TransactionsDailyGetPreviousMonthPressed());
  };

  Function onDailyTransactionsForwardPressed = () {
    return context.read<TransactionsDailyBloc>().add(TransactionsDailyGetNextMonthPressed());
  };

  return BlocBuilder<TransactionsDailyBloc, TransactionsDailyState>(builder: (context, state) {
    if (state is TransactionsDailyLoading)
      return DateRangeSlider(
          content: state.sliderCurrentTimeIntervalString, onForwardPressed: onDailyTransactionsForwardPressed, onBackPressed: onDailyTransactionsBackPressed);

    if (state is TransactionsDailyLoaded)
      return DateRangeSlider(
          content: state.sliderCurrentTimeIntervalString, onForwardPressed: onDailyTransactionsForwardPressed, onBackPressed: onDailyTransactionsBackPressed);

    return DateRangeSlider(content: '', onBackPressed: null, onForwardPressed: null);
  });
}

Widget _weeklySlider(BuildContext context) {
  Function onWeeklyTransactionsBackPressed = () {
    return context.read<TransactionsWeeklyBloc>().add(TransactionsWeeklyGetPreviousMonthPressed());
  };

  Function onWeeklyTransactionsForwardPressed = () {
    return context.read<TransactionsWeeklyBloc>().add(TransactionsWeeklyGetNextMonthPressed());
  };

  return BlocBuilder<TransactionsWeeklyBloc, TransactionsWeeklyState>(builder: (context, state) {
    if (state is TransactionsWeeklyLoading)
      return DateRangeSlider(
          content: state.sliderCurrentTimeIntervalString, onForwardPressed: onWeeklyTransactionsForwardPressed, onBackPressed: onWeeklyTransactionsBackPressed);

    if (state is TransactionsWeeklyLoaded)
      return DateRangeSlider(
          content: state.sliderCurrentTimeIntervalString, onForwardPressed: onWeeklyTransactionsForwardPressed, onBackPressed: onWeeklyTransactionsBackPressed);

    return DateRangeSlider(content: '', onBackPressed: null, onForwardPressed: null);
  });
}

Widget _monthlySlider(BuildContext context) {
  Function onMonthlyTransactionsBackPressed = () {
    return context.read<TransactionsMonthlyBloc>().add(TransactionsMonthlyGetPreviousYearPressed());
  };

  Function onMonthlyTransactionsForwardPressed = () {
    return context.read<TransactionsMonthlyBloc>().add(TransactionsMonthlyGetNextYearPressed());
  };

  return BlocBuilder<TransactionsMonthlyBloc, TransactionsMonthlyState>(builder: (context, state) {
    if (state is TransactionsMonthlyLoading)
      return DateRangeSlider(
          content: state.sliderCurrentTimeIntervalString,
          onForwardPressed: onMonthlyTransactionsForwardPressed,
          onBackPressed: onMonthlyTransactionsBackPressed);

    if (state is TransactionsMonthlyLoaded)
      return DateRangeSlider(
          content: state.sliderCurrentTimeIntervalString,
          onForwardPressed: onMonthlyTransactionsForwardPressed,
          onBackPressed: onMonthlyTransactionsBackPressed);

    return DateRangeSlider(content: '', onBackPressed: null, onForwardPressed: null);
  });
}

Widget _summarySlider(BuildContext context) {
  Function onSummaryTransactionsBackPressed = () {
    return context.read<TransactionsSummaryBloc>().add(TransactionsSummaryGetPreviousMonthPressed());
  };

  Function onSummaryTransactionsForwardPressed = () {
    return context.read<TransactionsSummaryBloc>().add(TransactionsSummaryGetNextMonthPressed());
  };

  return BlocBuilder<TransactionsSummaryBloc, TransactionsSummaryState>(builder: (context, state) {
    if (state is TransactionsSummaryLoading)
      return DateRangeSlider(content: state.sliderCurrentTimeIntervalString, onForwardPressed: onSummaryTransactionsForwardPressed, onBackPressed: onSummaryTransactionsBackPressed);

    if (state is TransactionsSummaryLoaded)
      return DateRangeSlider(content: state.sliderCurrentTimeIntervalString, onForwardPressed: onSummaryTransactionsForwardPressed, onBackPressed: onSummaryTransactionsBackPressed);

    return DateRangeSlider(content: '', onBackPressed: null, onForwardPressed: null);
  });
}

