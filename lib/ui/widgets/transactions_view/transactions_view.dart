import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_slider/transactions_slider_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/daily_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/monthly_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/summary_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/weekly_tab.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/widgets/transactions_slider.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsView extends StatefulWidget {
  @override
  _TransactionsViewState createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> with SingleTickerProviderStateMixin {
  TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = new TabController(length: 4, vsync: this);
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
