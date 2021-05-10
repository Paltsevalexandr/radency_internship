part of 'stats_bloc.dart';

enum StatsPageMode { stats, budget, note }
enum StatsTabMode { chart, map }

class StatsState extends Equatable {
  const StatsState({this.statsPageMode = StatsPageMode.stats, this.statsTabMode = StatsTabMode.chart});

  final StatsPageMode statsPageMode;
  final StatsTabMode statsTabMode;

  @override
  List<Object> get props => [statsPageMode, statsTabMode];

  StatsState copyWith({
    StatsPageMode statsPageMode,
    StatsTabMode statsTabMode,
  }) {
    return StatsState(
      statsPageMode: statsPageMode ?? this.statsPageMode,
      statsTabMode: statsTabMode ?? this.statsTabMode,
    );
  }

  StatsState toStatsMode({StatsTabMode statsTabMode}) {
    return copyWith(statsPageMode: StatsPageMode.stats, statsTabMode: statsTabMode);
  }

  StatsState toBudgetMode() {
    return copyWith(statsPageMode: StatsPageMode.budget);
  }

  StatsState toNoteMode() {
    return copyWith(statsPageMode: StatsPageMode.note);
  }
}
