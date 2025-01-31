part of 'baby_event_cubit.dart';

sealed class BabyEventState extends Equatable {
  const BabyEventState();
}

final class BabyEventInitial extends BabyEventState {
  @override
  List<Object> get props => [];
}

final class BabyEventProgress extends BabyEventState {
  @override
  List<Object> get props => [];
}

final class BabyEventLoaded extends BabyEventState {
  final List<BabyEvent> events;
  final Map<int, double> weightData;

  final FilterType filterType;
  final BabyEventType eventType;
  final DashboardModel? model;

  const BabyEventLoaded(this.events, this.filterType, this.eventType,
      this.weightData, this.model);

  @override
  List<Object?> get props => [events, weightData, filterType, eventType, model];
}
