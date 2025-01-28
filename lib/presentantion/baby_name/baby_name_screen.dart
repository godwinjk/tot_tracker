import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/router/route_path.dart';

import '../../persistence/shared_pref_const.dart';
import '../../util/setup_steps.dart';

class BabyNameScreen extends StatefulWidget {
  const BabyNameScreen({super.key});

  @override
  State<BabyNameScreen> createState() => _BabyNameScreenState();
}

class _BabyNameScreenState extends State<BabyNameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'Name of your Baby',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    final text = _controller.text;
                    if (text.isNotEmpty) {
                      _navigateToNext();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Please enter your baby name to continue'),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  void _navigateToNext() {
    SharedPreferences.getInstance().then((pref) {
      pref.setString(SharedPrefConstants.babyName, _controller.text);
      pref.setInt(SharedPrefConstants.setupSteps, SetupSteps.login);
      GetIt.instance<GoRouter>().replace(RoutePath.login);
    });
  }
}
