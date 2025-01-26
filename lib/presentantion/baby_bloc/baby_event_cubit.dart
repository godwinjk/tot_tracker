import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/db/database_helper.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/presentantion/model/baby_event.dart';
import 'package:tot_tracker/presentantion/model/baby_event_test_data.dart';
import 'package:tot_tracker/presentantion/model/baby_event_type.dart';
import 'package:tot_tracker/presentantion/model/selection_type.dart';
import 'package:tot_tracker/util/baby_event_util.dart';

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

  void load() async {
    final pref = await SharedPreferences.getInstance();
    final type = pref.getString(SharedPrefConstants.defaultFilterType) ??
        FilterType.week.toShortString();

    filterType = fromString(type);
    events = [];
    if (false) {
      events = await _databaseHelper.getBabyEvents();
    } else {
      events = BabyEventTestData.getTestData();
    }
    filter(type: filterType, eventType: filterEventType);
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

    emit(BabyEventLoaded(filterEvents, filterType, filterEventType));
  }

  void _filterBasedOnType(List<BabyEvent> events, FilterType type) {
    filterType = type;

    if (type == FilterType.day) {
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
