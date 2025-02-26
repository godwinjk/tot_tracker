import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tot_tracker/db/database_helper.dart';
import 'package:tot_tracker/presentantion/profile/bloc/profile_cubit.dart';
import 'package:tot_tracker/presentantion/schedule/bloc/schedule_cubit.dart';
import 'package:tot_tracker/presentantion/summary/bloc/summary_bloc_cubit.dart';
import 'package:tot_tracker/presentantion/user/signin/bloc/auth_cubit.dart';
import 'package:tot_tracker/presentantion/user/signin/bloc/sign_in_ui_cubit.dart';
import 'package:tot_tracker/theme/color_palette.dart';
import 'package:tot_tracker/theme/theme_cubit.dart';

import '../presentantion/home/baby_bloc/baby_event_cubit.dart';
import '../router/app_router.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(NeutralColorPalette()));
  getIt.registerSingleton<BabyEventCubit>(
      BabyEventCubit(getIt<DatabaseHelper>()));
  getIt.registerSingleton<SummaryCubit>(SummaryCubit(getIt<DatabaseHelper>()));
  getIt.registerSingleton<GoRouter>(router);
  getIt
      .registerSingleton<ScheduleCubit>(ScheduleCubit(getIt<DatabaseHelper>()));
  getIt.registerSingleton<AuthCubit>(AuthCubit());
  getIt.registerSingleton<SignInUiCubit>(SignInUiCubit());
  getIt.registerSingleton<ProfileCubit>(ProfileCubit());
}

void setColorPalette(ColorPalette colorPalette) {
  if (getIt.isRegistered<ColorPalette>()) {
    getIt.unregister<ColorPalette>();
  }
  getIt.registerSingleton<ColorPalette>(colorPalette);
}
