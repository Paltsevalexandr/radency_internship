import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'stats_event.dart';

part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(const StatsState());

  @override
  Stream<StatsState> mapEventToState(
    StatsEvent event,
  ) async* {
    if (event is StatsPageModeChanged) {
      yield* _mapStatsPageModeChangedToState(event.statsPageMode);
    } else if (event is StatsTabChanged) {
      yield* _mapStatsTabChangedToState(event.index);
    }
  }

  Stream<StatsState> _mapStatsPageModeChangedToState(StatsPageMode statsPageMode) async* {
    switch (statsPageMode) {
      case StatsPageMode.stats:
        yield state.toStatsMode();
        break;
      case StatsPageMode.budget:
        yield state.toBudgetMode();
        break;
      case StatsPageMode.note:
        yield state.toNoteMode();
        break;
    }
  }

  Stream<StatsState> _mapStatsTabChangedToState(int tabIndex) async* {
    switch (tabIndex) {
      case 0:
        yield state.toStatsMode(statsTabMode: StatsTabMode.chart);

        break;
      case 1:
        yield state.toStatsMode(statsTabMode: StatsTabMode.map);
        break;
    }
  }
}
