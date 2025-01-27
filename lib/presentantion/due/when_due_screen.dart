import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/res/asset_const.dart';
import 'package:tot_tracker/router/route_path.dart';

import '../../di/injection_base.dart';

class WhenAreDueScreen extends StatefulWidget {
  const WhenAreDueScreen({super.key});

  @override
  State<WhenAreDueScreen> createState() => _WhenAreDueScreenState();
}

class _WhenAreDueScreenState extends State<WhenAreDueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add some spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            // Center content horizontally
            children: [
              const Text(
                'When are you due?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Select Date',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to open date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Default date is today
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      // 1 year in the past
      lastDate:
          DateTime.now().add(const Duration(days: 365)), // 1 year in the future
    );

    if (picked != null) {
      SharedPreferences.getInstance().then((pref) {
        pref.setInt(SharedPrefConstants.dueDate, picked.millisecondsSinceEpoch);
        pref.setInt(SharedPrefConstants.setupSteps, 1);

        getIt<GoRouter>().go(RoutePath.gender);
      });
    }
  }
}
