import 'package:equatable/equatable.dart';
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

  final DatabaseHelper _databaseHelper;
  late List<BabyEvent> events;

  List<BabyEvent> filterEvents = [];

  FilterType filterType = FilterType.week;
  BabyEventType filterEventType = BabyEventType.all;
  late int babyBornEpoch;

  void load() async {
    final pref = await SharedPreferences.getInstance();
    final type = pref.getString(SharedPrefConstants.defaultFilterType) ??
        FilterType.week.toShortString();
    babyBornEpoch = pref.getInt(SharedPrefConstants.dueDate) ?? 0;
    filterType = fromString(type);
    events = [];
    if (TestUtil.isTesting) {
      events = BabyEventTestData.getTestData();
    } else {
      events = await _databaseHelper.getBabyEvents();
    }
    filter(type: filterType, eventType: filterEventType);
  }

  void loadForDashboard(FilterType type) async {
    final pref = await SharedPreferences.getInstance();
    // final type = pref.getString(SharedPrefConstants.defaultFilterType) ??
    //     FilterType.week.toShortString();
    babyBornEpoch = pref.getInt(SharedPrefConstants.dueDate) ?? 0;
    filterType = type;
    events = [];
    if (TestUtil.isTesting) {
      events = BabyEventTestData.getTestData();
    } else {
      events = await _databaseHelper.getBabyEvents();
    }

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

    final babyWeight = babyWeightMap.values.last;

    final milk = feed.fold(0.0, (sum, event) => sum + event.quantity);
    DashboardModel model = DashboardModel(
        feed: feed,
        wee: wee,
        weight: weight,
        poop: poop,
        type: type,
        babyWeight: babyWeight,
        consumedMilk: milk);

    emit(
        BabyEventLoaded(events, type, BabyEventType.all, babyWeightMap, model));
  }

  void addEvent(BabyEvent event) {
    _databaseHelper.insertBabyEvent(event);
    load();
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
    emit(BabyEventLoaded(
        filterEvents, filterType, filterEventType, babyWeightMap, null));
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
