import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/budget_overview/budget_overview_bloc.dart';
import 'package:radency_internship_project_2/ui/widgets/slider.dart';

class BudgetSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetOverviewBloc, BudgetOverviewState>(builder: (context, state) {
      if (state is BudgetOverviewLoading)
        return DateRangeSlider(
            content: state.sliderCurrentTimeIntervalString,
            onBackPressed: () {
              context.read<BudgetOverviewBloc>().add(BudgetOverviewGetPreviousMonthPressed());
            },
            onForwardPressed: () {
              context.read<BudgetOverviewBloc>().add(BudgetOverviewGetNextMonthPressed());
            });

      if (state is BudgetOverviewLoaded)
        return DateRangeSlider(
            content: state.sliderCurrentTimeIntervalString,
            onBackPressed: () {
              context.read<BudgetOverviewBloc>().add(BudgetOverviewGetPreviousMonthPressed());
            },
            onForwardPressed: () {
              context.read<BudgetOverviewBloc>().add(BudgetOverviewGetNextMonthPressed());
            });

      return DateRangeSlider(content: '', onBackPressed: () {}, onForwardPressed: () {});
    });
  }
}
