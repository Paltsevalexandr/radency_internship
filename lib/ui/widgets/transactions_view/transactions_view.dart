import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../blocs/transactions/transactions_slider/transactions_slider_bloc.dart';
import '../../../ui/widgets/transactions_view/tabs/daily_tab.dart';
import '../../../ui/widgets/transactions_view/tabs/monthly_tab.dart';
import '../../../ui/widgets/transactions_view/tabs/summary_tab.dart';
import '../../../ui/widgets/transactions_view/tabs/weekly_tab.dart';
import '../../../ui/widgets/transactions_view/widgets/transactions_slider.dart';
import '../../../utils/styles.dart';
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
    return TabBar(
      controller: controller,
      tabs: [
        Tab(child: Text(AppLocalizations
            .of(context)
            .transactionsTabTitleDaily, style: transactionsTabTitleStyle(context))),
        Tab(child: Text(AppLocalizations
            .of(context)
            .transactionsTabTitleWeekly, style: transactionsTabTitleStyle(context))),
        Tab(child: Text(AppLocalizations
            .of(context)
            .transactionsTabTitleMonthly, style: transactionsTabTitleStyle(context))),
        Tab(child: Text(AppLocalizations
            .of(context)
            .transactionsTabTitleSummary, style: transactionsTabTitleStyle(context))),
      ],
      indicatorColor: Colors.red,
    );
  }
}
