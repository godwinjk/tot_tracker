import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/router/route_path.dart';
import 'package:tot_tracker/theme/theme_cubit.dart';

import '../../../di/injection_base.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(const ProfileState(
            appVersion: '', babyName: '', gender: '', dueDate: null));

  String appVersion = '';
  String babyName = '';
  String gender = '';
  DateTime dueDate = DateTime.now();

  void initialize() async {
    final pref = await SharedPreferences.getInstance();
    babyName = pref.getString(SharedPrefConstants.babyName) ?? 'Not Given';
    gender = pref.getString(SharedPrefConstants.gender) ?? 'Not Given';
    await _loadAppVersion();
    _loadDueDate(pref.getInt(SharedPrefConstants.dueDate) ?? 0);

    emit(ProfileState(
        appVersion: appVersion,
        babyName: babyName,
        gender: gender,
        dueDate: dueDate));
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  void _loadDueDate(int millis) async {
    dueDate = DateTime.fromMillisecondsSinceEpoch(millis);
  }

  void updateBabyName(String newName) async {
    SharedPreferences.getInstance().then((pref) {
      pref.setString(SharedPrefConstants.babyName, newName);
      emit(state.copyWith(babyName: newName));
    });
  }

  void updateDueDate(DateTime newDate) async {
    SharedPreferences.getInstance().then((pref) {
      pref.setInt(SharedPrefConstants.dueDate, newDate.millisecondsSinceEpoch);
      _loadDueDate(newDate.millisecondsSinceEpoch);
      emit(state.copyWith(dueDate: dueDate));
    });
  }

  void updateGender(String newGender) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefConstants.gender, newGender);
    gender = newGender;
    getIt<ThemeCubit>().setGenderBasedTheme();
    emit(state.copyWith(gender: newGender));
  }

  Future<void> signOut() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    await FirebaseAuth.instance.signOut();
    getIt<GoRouter>().replace(RoutePath.splash);
  }
}
