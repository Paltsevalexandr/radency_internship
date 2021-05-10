part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
}

class StatsPageModeChanged extends StatsEvent {
  final StatsPageMode statsPageMode;

  StatsPageModeChanged({@required this.statsPageMode});

  @override
  List<Object> get props => [statsPageMode];
}

class StatsTabChanged extends StatsEvent {
  final int index;

  StatsTabChanged({@required this.index});

  @override
  List<Object> get props => [index];
}
