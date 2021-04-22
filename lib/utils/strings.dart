import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final String emailRegExp =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,"
    r"253}[a-zA-Z0-9])?)*$";

final String phoneNumberRegExp = r'^(?:[+])?[0-9]{9,16}$';

String getWeekDayByNumber(int num, BuildContext context) {
  switch (num) {
    case 1:
      return AppLocalizations.of(context).mondayShort;
    case 2:
      return AppLocalizations.of(context).tuesdayShort;
    case 3:
      return AppLocalizations.of(context).wednesdayShort;
    case 4:
      return AppLocalizations.of(context).thursdayShort;
    case 5:
      return AppLocalizations.of(context).fridayShort;
    case 6:
      return AppLocalizations.of(context).saturdayShort;
    case 7:
      return AppLocalizations.of(context).sundayShort;
  }
  return 'None';
}

String getMonthByNumber(BuildContext context, int num) {
  switch (num) {
    case 1:
      return AppLocalizations.of(context).januaryShort;
    case 2:
      return AppLocalizations.of(context).februaryShort;
    case 3:
      return AppLocalizations.of(context).marchShort;
    case 4:
      return AppLocalizations.of(context).aprilShort;
    case 5:
      return AppLocalizations.of(context).mayShort;
    case 6:
      return AppLocalizations.of(context).juneShort;
    case 7:
      return AppLocalizations.of(context).julyShort;
    case 8:
      return AppLocalizations.of(context).augustShort;
    case 9:
      return AppLocalizations.of(context).septemberShort;
    case 10:
      return AppLocalizations.of(context).octoberShort;
    case 11:
      return AppLocalizations.of(context).novemberShort;
    case 12:
      return AppLocalizations.of(context).decemberShort;
  }
  return 'None';
}
