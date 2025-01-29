import 'package:tot_tracker/presentantion/home/model/baby_event.dart';
import 'package:tot_tracker/presentantion/home/model/selection_type.dart';

class DashboardModel {
  final List<BabyEvent> feed;
  final List<BabyEvent> wee;
  final List<BabyEvent> weight;
  final List<BabyEvent> poop;
  final FilterType type;
  final double babyWeight;
  final double consumedMilk;

  DashboardModel(
      {required this.feed,
      required this.wee,
      required this.weight,
      required this.poop,
      required this.type,
      required this.babyWeight,
      required this.consumedMilk});
}
