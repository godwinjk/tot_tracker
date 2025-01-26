import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tot_tracker/presentantion/common/empty_placeholder_widget.dart';

import 'bloc/schedule_cubit.dart';
import 'model/notification_schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    context.read<ScheduleCubit>().load();
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocBuilder<ScheduleCubit, ScheduleState>(builder: (_, state) {
        if (state is ScheduleLoaded) {
          final notifications = state.notifications;
          return state.notifications.isEmpty
              ? const EmptyPlaceholderWidget(
                  subText: 'No Results found, try creating schedules',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final schedule = notifications[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(schedule.title),
                        subtitle: Text(
                            "${schedule.interval != 0 ? "Recurring" : "Once"} at ${DateTime.fromMillisecondsSinceEpoch(schedule.startTime).toLocal()}${schedule.interval != 0 ? ", every ${Duration(seconds: schedule.interval).inMinutes} mins" : ""}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => context
                              .read<ScheduleCubit>()
                              .removeSchedule(schedule),
                        ),
                      ),
                    );
                  },
                );
        } else if (state is ScheduleProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox.shrink();
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        child: const Icon(Icons.add),
      ),
    ));
  }

  void _showAddScheduleDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _messageController = TextEditingController();
    final _intervalController = TextEditingController();
    DateTime? _selectedStartTime;
    bool _isRecurring = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Schedule"),
          content: StatefulBuilder(builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: "Message"),
                  ),
                  SwitchListTile(
                    title: const Text("Recurring"),
                    value: _isRecurring,
                    onChanged: (value) {
                      _isRecurring = value;
                      state(() {});
                    },
                  ),
                  if (_isRecurring)
                    TextField(
                      controller: _intervalController,
                      decoration: const InputDecoration(
                          labelText: "Interval (minutes)"),
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );

                      if (pickedTime != null) {
                        _selectedStartTime = DateTime.now().copyWith(
                            hour: pickedTime.hour, minute: pickedTime.minute);
                      }
                    },
                    child: const Text("Pick Start Time"),
                  ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _messageController.text.isEmpty ||
                    _selectedStartTime == null ||
                    (_isRecurring && _intervalController.text.isEmpty)) {
                  return;
                }

                final schedule = NotificationSchedule(
                  title: _titleController.text,
                  message: _messageController.text,
                  startTime: _selectedStartTime!.millisecondsSinceEpoch,
                  interval: Duration(
                          minutes: int.tryParse(_intervalController.text) ?? 0)
                      .inSeconds,
                );

                context.read<ScheduleCubit>().addSchedule(schedule);
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _requestPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final IOSFlutterLocalNotificationsPlugin? iosPlatform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    // Check current permission status
    final bool? isGranted = await iosPlatform?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (isGranted != null && isGranted) {
      print("Notification permissions granted");
    } else {
      print("Notification permissions not granted");
    }
  }
}
