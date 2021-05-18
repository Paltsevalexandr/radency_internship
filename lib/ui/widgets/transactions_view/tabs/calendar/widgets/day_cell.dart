import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/models/calendar_day.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/tabs/calendar/widgets/calendar_day_dialog.dart';
import 'package:radency_internship_project_2/utils/strings.dart';

class DayCell extends StatelessWidget {
  const DayCell({Key key, @required this.day, @required this.maxHeight, @required this.maxWidth}) : super(key: key);

  final CalendarDay day;
  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState is LoadedSettingsState) {
          return GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CalendarDayDialog(
                      day: day,
                      currencySymbol: getCurrencySymbol(settingsState.currency),
                    );
                  });
            },
            child: Container(
              width: maxWidth / 7,
              height: maxHeight / 6,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day.displayedDate,
                    style: TextStyle(
                      color: day.isActive ? Theme.of(context).textTheme.bodyText1.color : Colors.grey,
                    ),
                  ),
                  Column(
                    children: [
                      value(context: context, value: day.incomeAmount, color: Colors.blue),
                      value(context: context, value: day.expensesAmount, color: Colors.red),
                      value(context: context, value: day.transferAmount),
                    ],
                  )
                ],
              ),
            ),
          );
        }

        return SizedBox();
      },
    );
  }

  Widget value({@required BuildContext context, double value, Color color}) {
    if (value == 0) {
      value = null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            value?.toStringAsFixed(2) ?? '',
            style: TextStyle(color: color ?? Theme.of(context).textTheme.bodyText1.color),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            maxLines: 1,
          ),
        )
      ],
    );
  }
}
