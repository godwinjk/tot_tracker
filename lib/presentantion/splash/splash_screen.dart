import 'dart:math' as math;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/res/asset_const.dart';
import 'package:tot_tracker/router/route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AssetConstant.lBabyFeeding,
                width: math.min(MediaQuery.sizeOf(context).height * 0.8,
                    MediaQuery.sizeOf(context).width * 0.8)),
            AnimatedTextKit(animatedTexts: [
              TyperAnimatedText('Baby Tracker',
                  speed: const Duration(milliseconds: 100),
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ))
            ])
          ],
        ),
      ),
    );
  }

  void navigateToNext() {
    Future.delayed(const Duration(seconds: 2), () {
      SharedPreferences.getInstance().then((pref) {
        final settingsCompleted =
            pref.getBool(SharedPrefConstants.settingsCompleted) ?? false;
        if (!settingsCompleted) {
          int due = pref.getInt(SharedPrefConstants.dueDate) ??
              DateTime.now().millisecondsSinceEpoch;
          if (due > 0 && due > DateTime.now().millisecondsSinceEpoch) {
            GetIt.instance<GoRouter>().replace(RoutePath.waiting);
            return;
          }
          int steps = pref.getInt(SharedPrefConstants.setupSteps) ?? 0;
          GetIt.instance<GoRouter>().replace(getPathBasedOnStep(steps));
        } else {
          GetIt.instance<GoRouter>().replace(RoutePath.home);
        }
      });

      GetIt.instance<GoRouter>().replace(RoutePath.login);
    });
  }

  String getPathBasedOnStep(int steps) {
    switch (steps) {
      case 0:
        return RoutePath.due;
      case 1:
        return RoutePath.gender;
      case 2:
        return RoutePath.babyName;
      case 3:
        return RoutePath.login;
      default:
        return RoutePath.home;
    }
  }
}
