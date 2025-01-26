import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tot_tracker/presentantion/schedule/model/notification_schedule.dart';

import '../../../db/database_helper.dart';
import '../../../notification/notification_service.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(DatabaseHelper databaseHelper)
      : _databaseHelper = databaseHelper,
        super(ScheduleInitial());
  final DatabaseHelper _databaseHelper;

  late List<NotificationSchedule> schedules;

  void load() async {
    schedules = await _databaseHelper.getAllNotificationSchedules();
    emit(ScheduleLoaded(schedules));
  }

  void addSchedule(NotificationSchedule schedule) async {
    // Schedule a notification

    int id = await _databaseHelper.createNotificationSchedule(schedule);
    if (schedule.interval > 0) {
      await NotificationService.scheduleNotification(
        id: id, // Unique ID
        title: schedule.title,
        body: schedule.message,
        scheduledTime: DateTime.fromMillisecondsSinceEpoch(schedule.startTime),
      );
    } else {
      await NotificationService.scheduleRecurringNotification(
          id: id,
          // Unique ID
          title: schedule.title,
          body: schedule.message,
          scheduledTime:
              DateTime.fromMillisecondsSinceEpoch(schedule.startTime),
          interval: Duration(seconds: schedule.interval));
    }
    load();
  }

  void removeSchedule(NotificationSchedule schedule) async {
    await NotificationService.cancelNotification(
      id: schedule.id ?? 0,
      // Unique ID
    );
    await _databaseHelper.deleteNotificationSchedule(schedule.id ?? 0);
    load();
  }
}
