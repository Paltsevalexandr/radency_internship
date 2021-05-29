import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/stats_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/stats/expenses_map/expenses_map_view.dart';
import 'package:radency_internship_project_2/utils/styles.dart';

import 'expenses_chart/chart_view.dart';

class StatsTabView extends StatefulWidget {
  @override
  _StatsTabViewState createState() => _StatsTabViewState();
}

class _StatsTabViewState extends State<StatsTabView> with SingleTickerProviderStateMixin {
  TabController tabBarController;

  @override
  void initState() {
    int initialIndex = 0;

    StatsState state = BlocProvider.of<StatsBloc>(context).state;
    switch (state.statsTabMode) {
      case StatsTabMode.chart:
        initialIndex = 0;
        break;
      case StatsTabMode.map:
        initialIndex = 1;
        break;
    }

    super.initState();
    tabBarController = new TabController(length: 2, vsync: this, initialIndex: initialIndex);
    tabBarController.addListener(() {
      context.read<StatsBloc>().add(StatsTabChanged(index: tabBarController.index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statsTabBar(context, tabBarController),
          _statsTabBarContent(),
        ],
      ),
    );
  }

  Widget _statsTabBar(BuildContext context, TabController controller) {
    final color = Theme.of(context).primaryColor;

    return TabBar(
      controller: controller,
      tabs: [
        Tab(child: Text(S.current.statsViewChartTab, style: tabTitleStyle(context).copyWith(color: Colors.black))),
        Tab(child: Text(S.current.statsViewMapTab, style: tabTitleStyle(context).copyWith(color: Colors.black))),
      ],
      indicatorColor: Colors.red,
    );
  }

  Widget _statsTabBarContent() {
    return BlocBuilder<StatsBloc, StatsState>(builder: (context, state) {
      switch (state.statsTabMode) {
        case StatsTabMode.chart:
          return ChartView();
          break;
        case StatsTabMode.map:
          return ExpensesMapView();
          break;
      }

      return SizedBox();
    });
  }
}
