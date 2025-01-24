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

  const BabyEventLoaded(this.events);

  @override
  List<Object> get props => [events];
}

