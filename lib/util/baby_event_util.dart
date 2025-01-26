import 'package:tot_tracker/presentantion/model/baby_event_type.dart';

import '../presentantion/model/baby_event.dart';

class BabyEventUtils {
  // Filter events by year
  static List<BabyEvent> filterByYear(List<BabyEvent> events, int year) {
    return events.where((event) {
      final eventDate = DateTime.fromMillisecondsSinceEpoch(event.eventTime);
      return eventDate.year == year;
    }).toList();
  }

  // Filter events by month
  static List<BabyEvent> filterByMonth(
      List<BabyEvent> events, int year, int month) {
    return events.where((event) {
      final eventDate = DateTime.fromMillisecondsSinceEpoch(event.eventTime);
      return eventDate.year == year && eventDate.month == month;
    }).toList();
  }

  // Filter events by week
  static List<BabyEvent> filterByWeek(
      List<BabyEvent> events, int year, int week) {
    return events.where((event) {
      final eventDate = DateTime.fromMillisecondsSinceEpoch(event.eventTime);
      final firstDayOfYear = DateTime(year, 1, 1);
      final weekNumber = ((eventDate.difference(firstDayOfYear).inDays) / 7)
          .ceil(); // Calculate week number
      return eventDate.year == year && weekNumber == week;
    }).toList();
  }

  static int getWeekOfYear(DateTime date) {
    // Get the first day of the year
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);

    // Calculate the difference in days between the date and the first day of the year
    int daysDifference = date.difference(firstDayOfYear).inDays;

    // Get the weekday of the first day of the year (1 = Monday, 7 = Sunday)
    int firstDayWeekday = firstDayOfYear.weekday;

    // Calculate the week number (adjusting for the first week's start day)
    int weekNumber = ((daysDifference + firstDayWeekday - 1) / 7).ceil();

    return weekNumber;
  }

  // Filter events by day
  static List<BabyEvent> filterByDay(
      List<BabyEvent> events, int year, int month, int day) {
    return events.where((event) {
      final eventDate = DateTime.fromMillisecondsSinceEpoch(event.eventTime);
      return eventDate.year == year &&
          eventDate.month == month &&
          eventDate.day == day;
    }).toList();
  }

  // Filter events by a selected date range
  static List<BabyEvent> filterByDateRange(
      List<BabyEvent> events, DateTime startDate, DateTime endDate) {
    return events.where((event) {
      final eventDate = DateTime.fromMillisecondsSinceEpoch(event.eventTime);
      return eventDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          eventDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  static List<BabyEvent> filterByType(
      List<BabyEvent> events, BabyEventType type) {
    return events.where((event) {
      return event.type == type;
    }).toList();
  }
}
