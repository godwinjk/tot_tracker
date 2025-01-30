import 'package:intl/intl.dart';

String formatEpochToHourMin(int epoch) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
  final formattedTime = DateFormat('HH:mm').format(dateTime);
  return formattedTime;
}


String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));
  DateTime inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (inputDate == today) {
    return "Today ${DateFormat('HH:mm').format(dateTime)}";
  } else if (inputDate == yesterday) {
    return "Yesterday ${DateFormat('HH:mm').format(dateTime)}";
  } else {
    return "${_getDayWithSuffix(dateTime.day)} ${DateFormat('MMM HH:mm').format(dateTime)}";
  }
}

/// Function to get ordinal suffix for day (e.g., 1st, 2nd, 3rd, 4th)
String _getDayWithSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "${day}th";
  }
  switch (day % 10) {
    case 1:
      return "${day}st";
    case 2:
      return "${day}nd";
    case 3:
      return "${day}rd";
    default:
      return "${day}th";
  }
}