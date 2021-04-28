import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/stats_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/widgets/bottom_nav_bar.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/budget_overview/budget_overview_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/spending_page/spending_page.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class StatsView extends StatefulWidget {
  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.stats),
      ),
      body: _body(),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _statsViewModeSlider(),
          BlocConsumer<StatsBloc, StatsState>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.statsPageMode) {
                case StatsPageMode.stats:
                  return SpendingPage();
                  break;
                case StatsPageMode.budget:
                  return BudgetOverviewTab();
                  break;
                case StatsPageMode.note:
                  // TODO: Handle this case.
                  break;
              }

              return SizedBox();
            },
          )
        ],
      ),
    );
  }

  Widget _statsViewModeSlider() {
    return Padding(
      padding: EdgeInsets.all(pixelsToDP(context, 16.0)),
      child: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          return CupertinoSlidingSegmentedControl(
              children: _statsViewSliderButtons(),
              groupValue: state.statsPageMode,
              onValueChanged: (value) {
                context.read<StatsBloc>().add(StatsModeChanged(statsPageMode: value));
              });
        },
      ),
    );
  }

  Map<StatsPageMode, Widget> _statsViewSliderButtons() {
    Map<StatsPageMode, Widget> statsButtons = {};

    StatsPageMode.values.forEach((statPageMode) {
      switch (statPageMode) {
        case StatsPageMode.stats:
          statsButtons[statPageMode] = _sliderButton(S.current.statsViewButtonStats);
          break;
        case StatsPageMode.budget:
          statsButtons[statPageMode] = _sliderButton(S.current.statsViewButtonBudget);
          break;
        case StatsPageMode.note:
          statsButtons[statPageMode] = _sliderButton(S.current.statsViewButtonNote);
          break;
      }
    });

    return statsButtons;
  }

  Widget _sliderButton(String title) {
    return Container(width: double.maxFinite, child: Center(child: Text(title)));
  }
}
