import 'package:equatable/equatable.dart';

import 'baby_event_type.dart';

class BabyEvent extends Equatable {
  final int? id;
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
      this.feedType = 'BreastFeed',
      this.id});

  @override
  List<Object?> get props => [
        id,
        type,
        eventTime,
        nursingTime,
        quantity,
        feedType,
        poopColor,
        info,
      ];

  // Convert BabyEvent to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(), // Store enum as string
      'eventTime': eventTime, // Store event time as integer
      'nursingTime': nursingTime, // Nursing duration as integer
      'quantity': quantity, // Quantity value as double
      'info': info, // Additional notes as text
      'poopColor': poopColor, // Poop color as text
      'feedType': feedType, // Feed type as text
    };
  }

  // Create a BabyEvent instance from a Map retrieved from the database
  static BabyEvent fromMap(Map<String, dynamic> map) {
    return BabyEvent(
      id: map['id'],
      type: BabyEventType.values.firstWhere((e) => e.toString() == map['type']),
      // Convert stored string back to enum
      eventTime: map['eventTime'],
      nursingTime: map['nursingTime'],
      quantity: map['quantity'],
      info: map['info'],
      poopColor: map['poopColor'],
      feedType: map['feedType'],
    );
  }
}
