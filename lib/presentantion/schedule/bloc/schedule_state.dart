part of 'schedule_cubit.dart';

sealed class ScheduleState extends Equatable {
  const ScheduleState();
}

final class ScheduleInitial extends ScheduleState {
  @override
  List<Object> get props => [];
}

final class ScheduleProgress extends ScheduleState {
  @override
  List<Object> get props => [];
}

final class ScheduleLoaded extends ScheduleState {
  final List<NotificationSchedule> notifications;

  const ScheduleLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}
