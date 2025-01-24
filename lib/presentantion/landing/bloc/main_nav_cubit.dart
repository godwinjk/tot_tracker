import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavCubit extends Cubit<MainNavCubitState> {
  MainNavCubit() : super(MainNavCubitState());

  void changeTab(int index) {
    emit(OnTabChangedState(index));
  }
}

class MainNavCubitState {}

class OnTabChangedState extends MainNavCubitState {
  final int index;

  OnTabChangedState(this.index);
}
