import 'package:equatable/equatable.dart';

class NotificationSchedule extends Equatable {
  final int? id; // Auto-incremented ID (primary key)
  final String title; // Title of the schedule
  final String message; // Message to display
  final int startTime; // Epoch time for the start
  final int interval; // Interval in seconds (0 for one-time)

  const NotificationSchedule({
    this.id,
    required this.title,
    required this.message,
    required this.startTime,
    required this.interval,
  });

  @override
  List<Object?> get props => [id, title, message, startTime, interval];

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'startTime': startTime,
      'interval': interval,
    };
  }

  // Create an instance from a Map
  static NotificationSchedule fromMap(Map<String, dynamic> map) {
    return NotificationSchedule(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      startTime: map['startTime'],
      interval: map['interval'],
    );
  }
}
