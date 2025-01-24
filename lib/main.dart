import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/di/injection_base.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/presentantion/baby_bloc/baby_event_cubit.dart';
import 'package:tot_tracker/router/app_router.dart';
import 'package:tot_tracker/theme/color_palette.dart';
import 'package:tot_tracker/theme/theme_cubit.dart';

void main() async {
  setupDi();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getIt<ThemeCubit>().updateTheme(BoyColorPalette(),
        isDarkMode: Theme.of(context).brightness == Brightness.dark);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ThemeCubit>()..setGenderBasedTheme(context),
        ),
        BlocProvider(
          create: (_) => getIt<BabyEventCubit>(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'Tot Tracker',
            theme: theme,
          );
        },
      ),
    );
  }
}
