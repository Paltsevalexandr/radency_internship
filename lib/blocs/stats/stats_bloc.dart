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
    if (event is StatsModeChanged) yield* _mapStatsModeChangedToState(event.statsPageMode);
  }

  Stream<StatsState> _mapStatsModeChangedToState(StatsPageMode statsPageMode) async* {

    print("StatsBloc._mapStatsModeChangedToState: $statsPageMode");

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
}
