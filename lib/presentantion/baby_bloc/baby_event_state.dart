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
  final FilterType filterType;
  final BabyEventType eventType;

  const BabyEventLoaded(this.events, this.filterType, this.eventType);

  @override
  List<Object> get props => [events];
}
