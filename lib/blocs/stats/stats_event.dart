part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
}

class StatsModeChanged extends StatsEvent {

  final StatsPageMode statsPageMode;

  StatsModeChanged({@required this.statsPageMode});

  @override
  List<Object> get props => [statsPageMode];
}
