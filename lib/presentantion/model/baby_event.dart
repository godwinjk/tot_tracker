import 'package:tot_tracker/presentantion/model/baby_event_type.dart';
import 'package:equatable/equatable.dart';

import 'baby_feed_type.dart';

class BabyEvent extends Equatable {
  final BabyEventType type;
  final int eventTime;
  final int nursingTime;
  final double quantity; //milk in ml, poop and wee on 5
  final String info;
  final String poopColor;
  final String feedType;

  const BabyEvent(
      {required this.type,
      required this.eventTime,
      required this.nursingTime,
      required this.quantity,
      required this.info,
      required this.poopColor,
      this.feedType = 'BreastFeed'});

  @override
  List<Object?> get props => [
        type,
        eventTime,
        nursingTime,
        quantity,
        feedType,
        poopColor,
        info,
      ];
}
