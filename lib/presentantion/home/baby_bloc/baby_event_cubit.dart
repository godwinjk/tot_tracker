import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/db/database_helper.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/presentantion/home/model/dashboard_model.dart';
import 'package:tot_tracker/util/baby_event_util.dart';

import '../../../util/test_util.dart';
import '../model/baby_event.dart';
import '../model/baby_event_test_data.dart';
import '../model/baby_event_type.dart';
import '../model/selection_type.dart';

part 'baby_event_state.dart';

class BabyEventCubit extends Cubit<BabyEventState> {
  BabyEventCubit(DatabaseHelper databaseHelper)
      : _databaseHelper = databaseHelper,
        super(BabyEventInitial());

  late FirebaseFirestore _db;
  late FirebaseAuth _firebaseAuth;

  final DatabaseHelper _databaseHelper;
  List<BabyEvent> events = [];

  List<BabyEvent> filterEvents = [];

  FilterType filterType = FilterType.week;
  BabyEventType filterEventType = BabyEventType.all;
  late int babyBornEpoch;

  void initial() {
    _db = FirebaseFirestore.instance;
    _firebaseAuth = FirebaseAuth.instance;
  }

  void load({
    BabyEventType eventType = BabyEventType.all,
  }) async {
    final pref = await SharedPreferences.getInstance();
    babyBornEpoch = pref.getInt(SharedPrefConstants.dueDate) ?? 0;

    filterEventType = eventType;

    events = [];
    if (TestUtil.isTesting) {
      events = BabyEventTestData.getTestData();
    } else {
      events = await _databaseHelper.getBabyEvents();
      final userId = _firebaseAuth.currentUser!.uid;
      events = await getBabyEvents(userId);
    }
    filter(type: filterType, eventType: filterEventType);
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

  DashboardModel afterGetData() {
    Map<int, double> babyWeightMap = {
      for (var event
          in BabyEventUtils.filterByType(events, BabyEventType.weight))
        getWeeksSinceBirth(event.eventTime, babyBornEpoch): event.quantity
    };
    final filterData = BabyEventUtils.filterByLast24(events, DateTime.now());
    final wee = BabyEventUtils.filterByType(filterData, BabyEventType.wee);
    final poop = BabyEventUtils.filterByType(filterData, BabyEventType.poop);
    final weight =
        BabyEventUtils.filterByType(filterData, BabyEventType.weight);

    final feed = BabyEventUtils.filterByType(filterData, BabyEventType.nursing);

    final babyWeight =
        babyWeightMap.values.isNotEmpty ? babyWeightMap.values.last : 0.0;

    final milk = feed.fold(0.0, (sum, event) => sum + event.quantity);
    return DashboardModel(
        feed: feed,
        wee: wee,
        weight: weight,
        poop: poop,
        type: filterType,
        babyWeight: babyWeight,
        consumedMilk: milk);
  }

  void addEvent(BabyEvent event) async {
    _databaseHelper.insertBabyEvent(event);

    try {
      final userId = _firebaseAuth.currentUser!.uid;
      _db
          .collection('Events')
          .doc(userId)
          .collection('baby_events')
          .doc('${event.eventTime}')
          .set(event.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
    // load();
  }

  void filter({FilterType? type, BabyEventType? eventType}) {
    filterEvents = events;
    if (type != null) {
      filterType = type;
    }
    _filterBasedOnType(filterEvents, filterType);

    if (eventType != null) {
      filterEventType = eventType;
    }
    _filterBasedOnEventType(filterEvents, filterEventType);

    Map<int, double> babyWeightMap = {
      for (var event
          in BabyEventUtils.filterByType(events, BabyEventType.weight))
        getWeeksSinceBirth(event.eventTime, babyBornEpoch): event.quantity
    };

    final model = afterGetData();
    emit(BabyEventLoaded(
        filterEvents, filterType, filterEventType, babyWeightMap, model));
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

  int getWeeksSinceBirth(int epochTime, int birthEpoch) {
    return ((epochTime - birthEpoch) / (7 * 24 * 60 * 60 * 1000)).floor();
  }
}
