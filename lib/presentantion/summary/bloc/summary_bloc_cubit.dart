import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';

import '../../../db/database_helper.dart';
import '../../../util/baby_event_util.dart';
import '../../../util/test_util.dart';
import '../../home/model/baby_event.dart';
import '../../home/model/baby_event_test_data.dart';
import '../../home/model/baby_event_type.dart';
import '../../home/model/selection_type.dart';
import '../model/average_data.dart';
import '../model/summary.dart';

part 'summary_bloc_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit(DatabaseHelper databaseHelper)
      : _databaseHelper = databaseHelper,
        super(SummaryInitial());
  final DatabaseHelper _databaseHelper;

  FilterType filterType = FilterType.week;
  BabyEventType filterEventType = BabyEventType.all;
  List<BabyEvent> filterEvents = [];
  late List<BabyEvent> events;

  late FirebaseFirestore _db;
  late FirebaseAuth _firebaseAuth;

  void initial() {
    _db = FirebaseFirestore.instance;
    _firebaseAuth = FirebaseAuth.instance;
  }

  void load() async {
    if (TestUtil.isTesting) {
      events = BabyEventTestData.getTestData();
    } else {
      // events = await _databaseHelper.getBabyEvents();
      final userId = _firebaseAuth.currentUser!.uid;
      events = await getBabyEvents(userId);
    }
    filter();
    processData();
  }

  /// 🔹 Fetch BabyEvents for a user and map them to a list
  Future<List<BabyEvent>> getBabyEvents(String userId) async {
    try {
      // Reference to the baby_events collection
      CollectionReference eventsRef =
          _db.collection('Events').doc(userId).collection('baby_events');

      // Fetch all documents
      QuerySnapshot snapshot =
          await eventsRef.orderBy('eventTime', descending: true).get();

      // Convert each document to a BabyEvent
      List<BabyEvent> events = snapshot.docs.map((doc) {
        return BabyEvent.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return events; // Return as a list
    } catch (e) {
      return [];
    }
  }

  void processData() async {
    final poopData = filterEvents
        .where((element) => element.type == BabyEventType.poop)
        .toList();
    final weeData = filterEvents
        .where((element) => element.type == BabyEventType.wee)
        .toList();
    final feedData = filterEvents
        .where((element) => element.type == BabyEventType.nursing)
        .toList();

    Map<int, int> poopDayBasis = {};
    Map<int, int> weeDayBasis = {};
    Map<int, int> feedDayBasis = {};

    if (filterType == FilterType.last24 || filterType == FilterType.day) {
      poopDayBasis = {1: poopData.length};
      weeDayBasis = {1: weeData.length};
      feedDayBasis = {1: feedData.length};
    } else {
      poopDayBasis = filterBasedOnDay(poopData);
      weeDayBasis = filterBasedOnDay(weeData);
      feedDayBasis = filterBasedOnDay(feedData);
    }
    final dob = await _getDob();
    final months = calculateAgeInMonths(dob);

    final poopUpper = poopDayBasis.map(
        (key, value) => MapEntry(key, AverageDataConst.poopUpper[months] ?? 0));
    final poopLower = poopDayBasis.map(
        (key, value) => MapEntry(key, AverageDataConst.poopLower[months] ?? 0));
    final weeUpper = weeDayBasis.map(
        (key, value) => MapEntry(key, AverageDataConst.weeUpper[months] ?? 0));
    final weeLower = weeDayBasis.map(
        (key, value) => MapEntry(key, AverageDataConst.weeLower[months] ?? 0));
    final feedUpper = feedDayBasis.map((key, value) =>
        MapEntry(key, AverageDataConst.feedsUpper[months] ?? 0));
    final feedLower = feedDayBasis.map((key, value) =>
        MapEntry(key, AverageDataConst.feedsLower[months] ?? 0));

    emit(SummaryLoaded(
        SummaryChartData(
          poopData: poopDayBasis,
          feedData: feedDayBasis,
          weeData: weeDayBasis,
          feedLowerData: feedLower,
          feedUpperData: feedUpper,
          poopLowerData: poopLower,
          poopUpperData: poopUpper,
          weeLowerData: weeLower,
          weeUpperData: weeUpper,
        ),
        filterType,
        filterEventType));
  }

  List<BabyEvent> filterBasedOnThisMonth(List<BabyEvent> events) {
    // Get the current date and time
    final now = DateTime.now();

    // Extract the current year and month
    final currentYear = now.year;
    final currentMonth = now.month;

    // Filter epoch times based on the current month
    return events.where((event) {
      // Convert epoch time to DateTime
      final dateTime = DateTime.fromMillisecondsSinceEpoch(event.eventTime);

      // Check if the year and month match the current year and month
      return dateTime.year == currentYear && dateTime.month == currentMonth;
    }).toList();
    // Print the filtered results
  }

  Map<int, int> filterBasedOnDay(List<BabyEvent> events) {
    // Step 1: Initialize an empty map for grouping by day
    // Step 1: Initialize an empty map for day-wise counts
    Map<int, int> dayWiseCounts = {};

    // Step 2: Iterate over the list of events
    for (var event in events) {
      // Convert epochTime to a DateTime object
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(event.eventTime);

      // Extract the day (1-31) from the DateTime object
      int day = dateTime.day;

      // Increment the count for this day in the map
      if (dayWiseCounts.containsKey(day)) {
        dayWiseCounts[day] = dayWiseCounts[day]! + 1;
      } else {
        dayWiseCounts[day] = 1;
      }
    }

    return dayWiseCounts;
  }

  Map<int, int> filterBasedOnWeek(List<BabyEvent> events) {
    // Step 1: Initialize an empty map for grouping by day
    // Step 1: Initialize an empty map for day-wise counts
    Map<int, int> dayWiseCounts = {};

    // Step 2: Iterate over the list of events
    for (var event in events) {
      // Convert epochTime to a DateTime object
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(event.eventTime);

      // Extract the day (1-31) from the DateTime object
      int day = dateTime.day;

      // Increment the count for this day in the map
      if (dayWiseCounts.containsKey(day)) {
        dayWiseCounts[day] = dayWiseCounts[day]! + 1;
      } else {
        dayWiseCounts[day] = 1;
      }
    }

    return dayWiseCounts;
  }

  Map<int, int> filterBasedOnHour(List<BabyEvent> events) {
    // Step 1: Initialize an empty map for grouping by day
    // Step 1: Initialize an empty map for day-wise counts
    Map<int, int> dayWiseCounts = {};

    // Step 2: Iterate over the list of events
    for (var event in events) {
      // Convert epochTime to a DateTime object
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(event.eventTime);

      // Extract the day (1-31) from the DateTime object
      int hour = dateTime.hour;

      // Increment the count for this day in the map
      if (dayWiseCounts.containsKey(hour)) {
        dayWiseCounts[hour] = dayWiseCounts[hour]! + 1;
      } else {
        dayWiseCounts[hour] = 1;
      }
    }

    return dayWiseCounts;
  }

  Future<DateTime> _getDob() async {
    final pref = await SharedPreferences.getInstance();
    int epoch = pref.getInt(SharedPrefConstants.dueDate) ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(epoch);
  }

  int calculateAgeInMonths(DateTime dob) {
    final now = DateTime.now();
    int yearsDifference = now.year - dob.year;
    int monthsDifference = now.month - dob.month;

    if (now.day < dob.day) {
      monthsDifference--; // Adjust if the current day is before the DOB day
    }
    return (yearsDifference * 12) + monthsDifference;
  }

  void filter({FilterType? type, BabyEventType? eventType, bool emit = false}) {
    filterEvents = events;
    if (type != null) {
      filterType = type;
    }
    _filterBasedOnType(filterEvents, filterType);

    if (eventType != null) {
      filterEventType = eventType;
    }
    _filterBasedOnEventType(filterEvents, filterEventType);
    processData();
  }

  void _filterBasedOnType(List<BabyEvent> events, FilterType type) {
    filterType = type;

    if (type == FilterType.last24) {
      final now = DateTime.now();
      filterEvents = BabyEventUtils.filterByLast24(events, now);
    } else if (type == FilterType.day) {
      final now = DateTime.now();
      filterEvents =
          BabyEventUtils.filterByDay(events, now.year, now.month, now.day);
    } else if (type == FilterType.week) {
      final now = DateTime.now();
      filterEvents = BabyEventUtils.filterByWeek(
        events,
        now.year,
        BabyEventUtils.getWeekOfYear(now),
      );
    } else if (type == FilterType.month) {
      final now = DateTime.now();
      filterEvents = BabyEventUtils.filterByMonth(
        events,
        now.year,
        now.month,
      );
    } else if (type == FilterType.year) {
      final now = DateTime.now();
      filterEvents = BabyEventUtils.filterByYear(events, now.year);
    } else {
      filterEvents = events;
    }
  }

  void _filterBasedOnEventType(List<BabyEvent> events, BabyEventType type) {
    if (type == BabyEventType.all) {
      filterEvents = events;
    } else {
      filterEvents = BabyEventUtils.filterByType(events, type);
    }
  }
}
