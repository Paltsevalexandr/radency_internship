import 'package:intl/intl.dart';
import 'package:radency_internship_project_2/utils/strings.dart';


class DateFormatters {

  String dateToTransactionDateString(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy (EEE)').format(dateTime);
  }

  String dateToString(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String yearFromDateTimeString(DateTime dateTime) {
    return DateFormat('y').format(dateTime);

  }

  String monthNameAndYearFromDateTimeString(DateTime dateTime, {String locale}) {
    return capitalizeFirstLetterOfEachWord(DateFormat('LLLL y', locale).format(dateTime));
  }

  String dateToNbuString(DateTime dateTime, {String locale}) {
    return DateFormat('ddMMyyyy').format(dateTime);
  }
}