import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'transactions_slider_event.dart';

part 'transactions_slider_state.dart';

enum TransactionsSliderMode { daily, weekly, monthly, summary, undefined }

class TransactionsSliderBloc extends Bloc<TransactionsSliderEvent, TransactionsSliderState> {
  TransactionsSliderBloc() : super(TransactionsSliderInitial());

  TransactionsSliderMode _currentTransactionsSliderMode;

  @override
  Stream<TransactionsSliderState> mapEventToState(
    TransactionsSliderEvent event,
  ) async* {
    if (event is TransactionsSliderInitialize) {
      yield* _mapTransactionsSliderInitializeToState();
    } else if (event is TransactionsSliderModeChanged) {
      yield* _mapTransactionsSliderModeChangedToState(tabIndex: event.index);
    }
  }

  Stream<TransactionsSliderState> _mapTransactionsSliderInitializeToState() async* {
    _currentTransactionsSliderMode = TransactionsSliderMode.daily;
    yield TransactionsSliderLoaded(transactionsSliderMode: _currentTransactionsSliderMode);
  }

  Stream<TransactionsSliderState> _mapTransactionsSliderModeChangedToState({@required int tabIndex}) async* {
    switch (tabIndex) {
      case 0:
        _currentTransactionsSliderMode = TransactionsSliderMode.daily;
        break;
      case 1:
        _currentTransactionsSliderMode = TransactionsSliderMode.weekly;
        break;
      case 2:
        _currentTransactionsSliderMode = TransactionsSliderMode.monthly;
        break;
      case 3:
        _currentTransactionsSliderMode = TransactionsSliderMode.summary;
        break;
      default:
        _currentTransactionsSliderMode = TransactionsSliderMode.undefined;
        break;
    }

    yield TransactionsSliderLoaded(transactionsSliderMode: _currentTransactionsSliderMode);
  }
}
