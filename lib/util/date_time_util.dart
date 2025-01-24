import 'package:intl/intl.dart';

String formatEpochToHourMin(int epoch) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
  final formattedTime = DateFormat('HH:mm').format(dateTime);
  return formattedTime;
}
