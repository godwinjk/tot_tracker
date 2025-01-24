import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tot_tracker/presentantion/baby_bloc/baby_event_cubit.dart';
import 'package:tot_tracker/theme/color_palette.dart';
import 'package:tot_tracker/theme/theme_cubit.dart';

import '../router/app_router.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(NeutralColorPalette()));
  getIt.registerSingleton<BabyEventCubit>(BabyEventCubit());
  getIt.registerSingleton<GoRouter>(router);
}
