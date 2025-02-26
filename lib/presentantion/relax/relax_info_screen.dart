import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/res/asset_const.dart';
import 'package:tot_tracker/router/route_path.dart';
import 'package:tot_tracker/util/setup_steps.dart';
import 'dart:math' as math;

import '../../di/injection_base.dart';

class RelaxInfoScreen extends StatefulWidget {
  const RelaxInfoScreen({super.key});

  @override
  State<RelaxInfoScreen> createState() => _RelaxInfoScreenState();
}

class _RelaxInfoScreenState extends State<RelaxInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the page
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Relax and Reflect',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // Center Lottie Animation
              Expanded(
                child: Center(
                  child: Lottie.asset(AssetConstant.lPregnancy,
                      // Path to your Lottie animation file
                      width: math.min(MediaQuery.sizeOf(context).height * 0.8,
                          MediaQuery.sizeOf(context).width * 0.8)),
                ),
              ),
              const SizedBox(height: 20),
              // Add spacing between Lottie and quote
              // Pregnancy Quote
              const Text(
                '"Life’s biggest miracle is the gift of having life growing inside of you."\n\nMay your days be filled with beautiful moments with your baby',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              // Push button to the bottom
              // Relax and Come Back Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    SharedPreferences.getInstance().then((pref) {
                      pref.setBool(
                          SharedPrefConstants.settingsCompleted, false);
                      pref.setInt(
                          SharedPrefConstants.setupSteps, SetupSteps.due);
                      pref.setInt(SharedPrefConstants.dueDate, -1);
                    });
                    getIt<GoRouter>().replace(
                        RoutePath.splash); // Go back to the previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    // Button color
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    // Add vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Relax and Come Back Again',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
