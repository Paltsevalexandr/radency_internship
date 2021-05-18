import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_slider/transactions_slider_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/calendar/calendar_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/daily_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/monthly_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/summary_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/weekly_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/widgets/transactions_slider.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsContent extends StatefulWidget {
  @override
  _TransactionsContentState createState() => _TransactionsContentState();
}

class _TransactionsContentState extends State<TransactionsContent> with SingleTickerProviderStateMixin {
  TabController tabBarController;

  @override
  void initState() {
    super.initState();
    int initialIndex = 0;
    var state = context.read<TransactionsSliderBloc>().state;
    if (state is TransactionsSliderLoaded) {
      switch (state.transactionsSliderMode) {
        case TransactionsSliderMode.daily:
          initialIndex = 0;
          break;
        case TransactionsSliderMode.calendar:
          initialIndex = 1;
          break;
        case TransactionsSliderMode.weekly:
          initialIndex = 2;
          break;
        case TransactionsSliderMode.monthly:
          initialIndex = 3;
          break;
        case TransactionsSliderMode.summary:
          initialIndex = 4;
          break;
      }
    }
    tabBarController = new TabController(length: 5, vsync: this, initialIndex: initialIndex);
    tabBarController.addListener(() {
      context.read<TransactionsSliderBloc>().add(TransactionsSliderModeChanged(index: tabBarController.index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TransactionsTabSlider(),
            transactionsTabBar(context, tabBarController),
            Expanded(
              child: TabBarView(
                controller: tabBarController,
                children: [
                  DailyTab(),
                  CalendarTab(),
                  WeeklyTab(),
                  MonthlyTab(),
                  SummaryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionsTabBar(BuildContext context, TabController controller) {
    return Container(
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabs: [
          Tab(
            child: tabTitle(S.current.transactionsTabTitleDaily),
          ),
          Tab(
            child: tabTitle(S.current.transactionsTabTitleCalendar),
          ),
          Tab(
            child: tabTitle(S.current.transactionsTabTitleWeekly),
          ),
          Tab(
            child: tabTitle(S.current.transactionsTabTitleMonthly),
          ),
          Tab(
            child: tabTitle(S.current.transactionsTabTitleSummary),
          ),
        ],
        indicatorColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget tabTitle(String localizedTitle) {
    return Text(
      localizedTitle,
      style: tabTitleStyle(context),
    );
  }
}
