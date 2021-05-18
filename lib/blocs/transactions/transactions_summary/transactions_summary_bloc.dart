import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/models/expense_item.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';

part 'transactions_summary_event.dart';

part 'transactions_summary_state.dart';

class TransactionsSummaryBloc extends Bloc<TransactionsSummaryEvent, TransactionsSummaryState> {
  TransactionsSummaryBloc({@required this.settingsBloc}) : super(TransactionsSummaryInitial());

  SettingsBloc settingsBloc;
  StreamSubscription settingsSubscription;
  String locale = '';

  StreamSubscription summaryTransactionsSubscription;

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  ExpenseSummaryItemEntity expenseSummaryItemEntity;

  @override
  Future<void> close() {
    summaryTransactionsSubscription?.cancel();
    settingsSubscription?.cancel();

    return super.close();
  }

  @override
  Stream<TransactionsSummaryState> mapEventToState(
    TransactionsSummaryEvent event,
  ) async* {
    if (event is TransactionsSummaryInitialize) {
      yield* _mapTransactionsSummaryInitializeToState();
    } else if (event is TransactionsSummaryGetPreviousMonthPressed) {
      yield* _mapTransactionsSummaryGetPreviousMonthPressedToState();
    } else if (event is TransactionsSummaryGetNextMonthPressed) {
      yield* _mapTransactionsSummaryGetNextMonthPressedToState();
    } else if (event is TransactionsSummaryFetchRequested) {
      yield* _mapTransactionsSummaryFetchRequestedToState(dateForFetch: event.dateForFetch);
    } else if (event is TransactionSummaryDisplayRequested) {
      yield* _mapTransactionSummaryDisplayRequestedToState(
          event.sliderCurrentTimeIntervalString, event.expenseSummaryItemEntity);
    } else if (event is TransactionsSummaryLocaleChanged) {
      yield* _mapTransactionsSummaryLocaleChangedToState();
    }
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryInitializeToState() async* {
    _observedDate = DateTime.now();
    add(TransactionsSummaryFetchRequested(dateForFetch: _observedDate));

    if (settingsBloc.state is LoadedSettingsState) locale = settingsBloc.state.language;
    settingsBloc.stream.listen((newSettingsState) {
      if (newSettingsState is LoadedSettingsState) {
        if (newSettingsState.language != locale) {
          locale = newSettingsState.language;

          add(TransactionsSummaryLocaleChanged());
        }
      }
    });
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryLocaleChangedToState() async* {
    _sliderCurrentTimeIntervalString =
        DateFormatters().monthNameAndYearFromDateTimeString(_observedDate, locale: locale);
    if (state is TransactionsSummaryLoaded) {
      add(TransactionSummaryDisplayRequested(
          expenseSummaryItemEntity: expenseSummaryItemEntity,
          sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString));
    } else if (state is TransactionsSummaryLoading) {
      yield TransactionsSummaryLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    }
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryFetchRequestedToState(
      {@required DateTime dateForFetch}) async* {
    summaryTransactionsSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateFormatters().monthNameAndYearFromDateTimeString(_observedDate);
    yield TransactionsSummaryLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    summaryTransactionsSubscription = Future.delayed(Duration(seconds: 2)).asStream().listen((event) {
      // TODO: Implement fetch endpoint
       expenseSummaryItemEntity = MockedExpensesItems().generateSummaryData();
      add(TransactionSummaryDisplayRequested(
          sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
          expenseSummaryItemEntity: expenseSummaryItemEntity));
    });
  }

  Stream<TransactionsSummaryState> _mapTransactionSummaryDisplayRequestedToState(
      String data, ExpenseSummaryItemEntity expenseSummaryItemEntity) async* {
    yield TransactionsSummaryLoaded(
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString,
        expenseSummaryItemEntity: expenseSummaryItemEntity);
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(TransactionsSummaryFetchRequested(dateForFetch: _observedDate));
  }

  Stream<TransactionsSummaryState> _mapTransactionsSummaryGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(TransactionsSummaryFetchRequested(dateForFetch: _observedDate));
  }
}
