import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import '../../blocs/expenses_list/daily_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../blocs/transactions/transactions_daily/transactions_daily_bloc.dart';
import '../../models/expense_item.dart';
import '../../utils/mocked_expenses.dart';
import '../../utils/strings.dart';
import '../../utils/ui_utils.dart';

import 'common_expenses_list.dart';

Widget buildDailyExpensesList(BuildContext context) {
  return BlocBuilder<TransactionsDailyBloc, TransactionsDailyState>(
      builder: (context, state) {
    if (state is TransactionsDailyLoaded) {
      var data = state.data;

      var sliversMap = List<_StickyExpensesDaily>.empty(growable: true);

      data.forEach((key, value) {
        sliversMap.add(_StickyExpensesDaily(items: value));
      });

      return Scaffold(
        body: CustomScrollView(
          slivers: sliversMap,
        ),
      );
    }

    return null;
  });
}

class DailyExpensesList extends StatelessWidget {
  final _expItemsBloc = ItemsBloc();

  DailyExpensesList({
    Key key,
  }) : super(key: key) {
    _expItemsBloc.loadItems(MockedExpensesItems().generateDailyData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _expItemsBloc.itemsStream,
          initialData: {},
          builder: (context, snapshot) {
            var data = snapshot.data;

            var sliversMap = List<_StickyExpensesDaily>.empty(growable: true);

            data.forEach((key, value) {
              sliversMap.add(_StickyExpensesDaily(items: value));
            });

            return CustomScrollView(
              slivers: sliversMap,
            );
          }),
    );
  }
}

class _StickyExpensesDaily extends StatelessWidget {
  const _StickyExpensesDaily({Key key, this.items}) : super(key: key);

  final List<ExpenseItemEntity> items;

  @override
  Widget build(BuildContext context) {
    var totalIncome = 0.0;
    var totalOutcome = 0.0;

    items.forEach((element) {
      if (element.type == ExpenseType.income) {
        totalIncome += element.amount;
      } else if (element.type == ExpenseType.outcome) {
        totalOutcome += element.amount;
      }
    });

    return SliverStickyHeader(
      header: DailyExpensesHeader(
        dateTime: items[0].dateTime,
        incomeTotal: totalIncome,
        outcomeTotal: totalOutcome,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ListTile(
            title: DailyExpensesItem(itemEntity: items[i]),
          ),
          childCount: items.length,
        ),
      ),
    );
  }
}

class DailyExpensesItem extends StatelessWidget {
  const DailyExpensesItem({
    Key key,
    this.itemEntity,
  }) : super(key: key);

  final ExpenseItemEntity itemEntity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      String currency = state.currency;
      return Container(
          height: pixelsToDP(context, 150),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: pixelsToDP(context, 24)),
                child: Text('${itemEntity.category}',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: pixelsToDP(context, 24)),
                  child: Text('${itemEntity.description}',
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              Text(
                '${getCurrencySymbol(currency)} ${itemEntity.amount.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: itemEntity.type == ExpenseType.income
                        ? Colors.blue
                        : itemEntity.type == ExpenseType.outcome
                            ? Colors.redAccent
                            : Colors.grey,
                    fontSize: 18),
              ),
            ],
          ));
    });
  }
}

class DailyExpensesHeader extends StatelessWidget {
  const DailyExpensesHeader({
    Key key,
    this.dateTime,
    this.incomeTotal = 0.0,
    this.outcomeTotal = 0.0,
  }) : super(key: key);

  final DateTime dateTime;
  final double incomeTotal;
  final double outcomeTotal;

  Widget buildBigDayText(context) {
    return Padding(
      padding: EdgeInsets.only(
          right: pixelsToDP(context, 24), left: pixelsToDP(context, 36)),
      child: Text(
        '${dateTime.day}',
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 32),
      ),
    );
  }

  Widget buildDateColumn(BuildContext context) {
    const greyColor = Color(0xff8d8d8d);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${dateTime.month}.${dateTime.year}',
          style: const TextStyle(color: greyColor, fontSize: 18),
        ),
        Container(
          decoration: new BoxDecoration(
              color: greyColor,
              borderRadius: new BorderRadius.all(
                  Radius.circular(pixelsToDP(context, 4)))),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: pixelsToDP(context, 2),
                horizontal: pixelsToDP(context, 4)),
            child: Text(
              '${getWeekDayByNumber(dateTime.weekday, context)}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      String currency = state.currency;
      return Container(
          height: pixelsToDP(context, 200),
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: pixelsToDP(context, 8)),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              buildBigDayText(context),
              buildDateColumn(context),
              Expanded(child: SizedBox()),
              buildIncomeText(
                  context, getCurrencySymbol(currency), incomeTotal),
              buildOutcomeText(
                  context, getCurrencySymbol(currency), outcomeTotal)
            ],
          ));
    });
  }
}
