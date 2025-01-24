import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tot_tracker/presentantion/model/baby_event.dart';

part 'baby_event_state.dart';

class BabyEventCubit extends Cubit<BabyEventState> {
  BabyEventCubit() : super(BabyEventInitial());

  late List<BabyEvent> events;

  void load() {
    events = [];
    emit(BabyEventLoaded(events));
  }

  void addEvent(BabyEvent event) {
    events.add(event);
    emit(BabyEventLoaded(events));
  }
}
