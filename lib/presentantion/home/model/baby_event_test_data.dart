import 'dart:math';

import 'baby_event.dart';
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
    events.addAll(generateBabyWeightEvents());
    // Sort events by eventTime
    events.sort((a, b) => a.eventTime.compareTo(b.eventTime));


    return events;
  }

  // Generate a random event time within a specific week
  static int generateRandomEventTimeForWeight(
      int year, int month, int week, Random random) {
    DateTime startOfWeek =
        DateTime(year, month, 1).add(Duration(days: week * 7));
    return startOfWeek.millisecondsSinceEpoch +
        random.nextInt(7 * 24 * 60 * 60 * 1000); // Random within that week
  }

// Generate 52-week weight events
  static List<BabyEvent> generateBabyWeightEvents() {
    Random random = Random();
    List<BabyEvent> babyWeightEvents = [];
    double weight = 3.0; // Start weight at birth

    for (int week = 0; week < 52; week++) {
      babyWeightEvents.add(BabyEvent(
        type: BabyEventType.weight,
        eventTime: generateRandomEventTimeForWeight(2025, 1, week, random),
        quantity: double.parse(weight.toStringAsFixed(2)),
        // Round to 2 decimals
        info: 'Weight recorded at week $week',
        nursingTime: 0,
        poopColor: '',
      ));
      weight +=
          0.15 + (random.nextDouble() * 0.05); // Increase weight gradually
    }

    return babyWeightEvents;
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
