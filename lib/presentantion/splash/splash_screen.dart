import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/res/asset_const.dart';
import 'package:tot_tracker/router/route_path.dart';
import 'dart:math' as math;

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
              TyperAnimatedText('Tot\nTracker',
                  speed: Duration(milliseconds: 100),
                  textAlign: TextAlign.center,
                  textStyle:
                      TextStyle(fontSize: 35, fontWeight: FontWeight.bold))
            ])
          ],
        ),
      ),
    );
  }

  void navigateToNext() {
    Future.delayed(const Duration(seconds: 2), () {
      SharedPreferences.getInstance().then((pref) {
        final gender = pref.getString(SharedPrefConstants.gender) ?? '';
        if (gender.isEmpty || gender == 'any') {
          GetIt.instance<GoRouter>().replace(RoutePath.gender);
        } else {
          GetIt.instance<GoRouter>().replace(RoutePath.home);
        }
      });
    });
  }
}
