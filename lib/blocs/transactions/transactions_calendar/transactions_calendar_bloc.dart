import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_calendar/mocked_calendar_data.dart';
import 'package:radency_internship_project_2/models/calendar_day.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/income_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';

part 'transactions_calendar_event.dart';

part 'transactions_calendar_state.dart';

class TransactionsCalendarBloc extends Bloc<TransactionsCalendarEvent, TransactionsCalendarState> {
  TransactionsCalendarBloc({@required this.settingsBloc}) : super(TransactionsCalendarInitial());

  SettingsBloc settingsBloc;
  StreamSubscription settingsSubscription;
  String locale = '';

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  var calendarData;
  double expensesSummary = 0;
  double incomeSummary = 0;

  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  final int startOfWeek = 1;
  final int endOfWeek = 7;

  StreamSubscription calendarTransactionsSubscription;

  @override
  Stream<TransactionsCalendarState> mapEventToState(
    TransactionsCalendarEvent event,
  ) async* {
    if (event is TransactionsCalendarInitialize) {
      yield* _mapTransactionsCalendarInitializeToState();
    } else if (event is TransactionsCalendarGetPreviousMonthPressed) {
      yield* _mapTransactionsCalendarGetPreviousMonthPressedToState();
    } else if (event is TransactionsCalendarGetNextMonthPressed) {
      yield* _mapTransactionsCalendarGetNextMonthPressedToState();
    } else if (event is TransactionsCalendarFetchRequested) {
      yield* _mapTransactionsCalendarFetchRequestedToState(dateForFetch: event.dateForFetch);
    } else if (event is TransactionsCalendarDisplayRequested) {
      yield* _mapTransactionCalendarDisplayRequestedToState(
        data: event.daysData,
        expenses: event.expensesSummary,
        income: event.incomeSummary,
      );
    } else if (event is TransactionsCalendarLocaleChanged) {
      yield* _mapTransactionsCalendarLocaleChangedToState();
    }
  }

  @override
  Future<void> close() {
    calendarTransactionsSubscription?.cancel();
    settingsSubscription?.cancel();
    print("TransactionsCalendarBloc.close: ");
    return super.close();
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarInitializeToState() async* {
    _observedDate = DateTime.now();
    add(TransactionsCalendarFetchRequested(dateForFetch: _observedDate));

    if (settingsBloc.state is LoadedSettingsState) {
      locale = settingsBloc.state.language;
    }
    settingsBloc.stream.listen((newSettingsState) {
      print("TransactionsCalendarBloc._mapTransactionsCalendarInitializeToState: newSettingsState");
      if (newSettingsState is LoadedSettingsState && newSettingsState.language != locale) {
        locale = newSettingsState.language;
        add(TransactionsCalendarLocaleChanged());
      }
    });
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarLocaleChangedToState() async* {
    _sliderCurrentTimeIntervalString =
        DateFormatters().monthNameAndYearFromDateTimeString(_observedDate, locale: locale);

    print("TransactionsCalendarBloc._mapTransactionsCalendarLocaleChangedToState: $_sliderCurrentTimeIntervalString");

    if (state is TransactionsCalendarLoaded) {
      add(TransactionsCalendarDisplayRequested(
        daysData: calendarData,
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
        expensesSummary: expensesSummary,
        incomeSummary: incomeSummary,
      ));
    } else if (state is TransactionsCalendarLoading) {
      yield TransactionsCalendarLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    }
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarFetchRequestedToState(
      {@required DateTime dateForFetch}) async* {
    calendarTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateFormatters().monthNameAndYearFromDateTimeString(_observedDate);
    yield TransactionsCalendarLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    calendarTransactionsSubscription = Future.delayed(Duration(seconds: 2)).asStream().listen((event) {
      // TODO: Implement fetch endpoint

      List<Transaction> transactions = MockedCalendarData().generateMonthlyTransactions(dateTime: dateForFetch);
      calendarData = _convertTransactionsToCalendarData(transactions, _observedDate);
      add(TransactionsCalendarDisplayRequested(
        daysData: calendarData,
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
        expensesSummary: expensesSummary,
        incomeSummary: incomeSummary,
      ));
    });
  }

  Stream<TransactionsCalendarState> _mapTransactionCalendarDisplayRequestedToState(
      {@required List<CalendarDay> data, @required double income, @required double expenses}) async* {
    yield TransactionsCalendarLoaded(
        daysData: data,
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
        incomeSummary: income,
        expensesSummary: expenses);
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(TransactionsCalendarFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsCalendarState> _mapTransactionsCalendarGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(TransactionsCalendarFetchRequested(dateForFetch: _observedDate));
  }

  List<CalendarDay> _convertTransactionsToCalendarData(List<Transaction> transactions, DateTime observedDateTime) {
    List<CalendarDay> days = [];
    incomeSummary = 0;
    expensesSummary = 0;

    int currentMonth = observedDateTime.month;

    DateTime observedDay = DateTime(observedDateTime.year, observedDateTime.month, 1);
    while (observedDay.weekday != startOfWeek) {
      observedDay = DateTime(observedDay.year, observedDay.month, observedDay.day - 1);
    }

    while (days.length != 42) {
      List<Transaction> dayTransactions = [];
      String displayedDate = observedDay.day == 1 ? '${observedDay.day}.${observedDay.month}' : '${observedDay.day}';
      double expensesAmount = 0;
      double incomeAmount = 0;
      double transferAmount = 0;

      if (observedDay.month == currentMonth) {
        transactions.forEach((element) {
          if (element.dateTime.month == observedDay.month && element.dateTime.day == observedDay.day) {
            dayTransactions.add(element);

            if (element is ExpenseTransaction) {
              expensesAmount = expensesAmount + element.amount;
              expensesSummary = expensesSummary + element.amount;
            } else if (element is IncomeTransaction) {
              incomeAmount = incomeAmount + element.amount;
              incomeSummary = incomeSummary + element.amount;
            } else if (element is TransferTransaction) {
              transferAmount = transferAmount + element.amount;
            }
          }
        });
      }

      days.add(CalendarDay(
          dateTime: observedDay,
          displayedDate: displayedDate,
          isActive: observedDay.month == currentMonth,
          transactions: dayTransactions,
          expensesAmount: expensesAmount,
          incomeAmount: incomeAmount,
          transferAmount: transferAmount));

      observedDay = DateTime(observedDay.year, observedDay.month, observedDay.day + 1);
    }

    return days;
  }
}
