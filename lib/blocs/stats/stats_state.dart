part of 'stats_bloc.dart';

enum StatsPageMode { stats, budget, note }

class StatsState extends Equatable {
  const StatsState({this.statsPageMode = StatsPageMode.budget});

  final StatsPageMode statsPageMode;

  @override
  List<Object> get props => [statsPageMode];

  StatsState copyWith({
    StatsPageMode statsPageMode,
  }) {
    return StatsState(
      statsPageMode: statsPageMode ?? this.statsPageMode,
    );
  }

  StatsState toStatsMode() {
    return copyWith(statsPageMode: StatsPageMode.stats);
  }

  StatsState toBudgetMode() {
    return copyWith(statsPageMode: StatsPageMode.budget);
  }

  StatsState toNoteMode() {
    return copyWith(statsPageMode: StatsPageMode.note);
  }
}
