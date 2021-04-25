import 'package:intl/intl.dart';


class DateFormatters {

  String dateToTransactionDateString(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy (EEE)').format(dateTime);
  }

  String yearFromDateTimeString(DateTime dateTime) {
    return DateFormat('y').format(dateTime);

  }

  String monthNameAndYearFromDateTimeString(DateTime dateTime) {
    return  DateFormat('MMMM y').format(dateTime);
  }
}