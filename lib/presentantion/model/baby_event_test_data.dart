import 'dart:math';

import 'package:tot_tracker/presentantion/model/baby_event.dart';

import 'baby_event_type.dart';

class BabyEventTestData {
  static List<BabyEvent> getTestData() {
    final random = Random();
    List<BabyEvent> events = [];

    // Loop through each day in January
    for (int day = 1; day <= 31; day++) {
      // Generate random number of events (2 to 8) for each type
      int nursingCount = random.nextInt(7) + 2; // 2 to 8
      int poopCount = random.nextInt(7) + 2; // 2 to 8
      int weeCount = random.nextInt(7) + 2; // 2 to 8

      // Generate random nursing events for the day
      for (int i = 0; i < nursingCount; i++) {
        events.add(
          BabyEvent(
            type: BabyEventType.nursing,
            eventTime: generateRandomEventTime(2025, 1, day, random),
            nursingTime: random.nextInt(20) + 5,
            // 5 to 35 minutes
            quantity: random.nextInt(20) + 20,
            // 50ml to 150ml
            info: 'Nursing event',
            poopColor: '',
            feedType: 'BreastFeed',
          ),
        );
      }

      // Generate random poop events for the day
      for (int i = 0; i < poopCount; i++) {
        events.add(
          BabyEvent(
            type: BabyEventType.poop,
            eventTime: generateRandomEventTime(2025, 1, day, random),
            nursingTime: 0,
            quantity: random.nextDouble() * 5,
            // Poop scale 0 to 5
            info: 'Poop event',
            poopColor: generateRandomPoopColor(random),
            feedType: '',
          ),
        );
      }

      // Generate random wee events for the day
      for (int i = 0; i < weeCount; i++) {
        events.add(
          BabyEvent(
            type: BabyEventType.wee,
            eventTime: generateRandomEventTime(2025, 1, day, random),
            nursingTime: 0,
            quantity: random.nextDouble() * 5,
            // Wee scale 0 to 5
            info: 'Wee event',
            poopColor: '',
            feedType: '',
          ),
        );
      }
    }

    // Sort events by eventTime
    events.sort((a, b) => a.eventTime.compareTo(b.eventTime));

    // Print results
    for (var event in events) {
      print(event);
    }

    return events;
  }

// Helper function to generate a random event time for a specific day
  static int generateRandomEventTime(
      int year, int month, int day, Random random) {
    DateTime startOfDay = DateTime(year, month, day, 0, 0);
    return startOfDay.millisecondsSinceEpoch +
        random.nextInt(24 * 60 * 60 * 1000); // Random time within the day
  }

// Helper function to generate random poop colors
  static String generateRandomPoopColor(Random random) {
    const colors = ['Yellow', 'Green', 'Brown', 'Dark Brown', 'Black'];
    return colors[random.nextInt(colors.length)];
  }
}
