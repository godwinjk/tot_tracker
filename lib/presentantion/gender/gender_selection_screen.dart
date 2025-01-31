import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/persistence/shared_pref_const.dart';
import 'package:tot_tracker/res/asset_const.dart';
import 'package:tot_tracker/theme/color_palette.dart';
import 'package:tot_tracker/theme/theme_cubit.dart';
import 'package:tot_tracker/util/setup_steps.dart';

import '../../router/route_path.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? _selectedGender;
  late ConfettiController _confettiControllerBoy;
  late ConfettiController _confettiControllerGirl;
  late ConfettiController _confettiControllerAny;

  @override
  void initState() {
    super.initState();
    _loadSelectedGender();
    _confettiControllerBoy =
        ConfettiController(duration: Duration(milliseconds: 1200));
    _confettiControllerGirl =
        ConfettiController(duration: Duration(milliseconds: 1200));
    _confettiControllerAny =
        ConfettiController(duration: Duration(milliseconds: 1200));
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    // final dimen = math.min(size.width, size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      _buildGenderCard(
                          label: 'Boy',
                          assetPath: AssetConstant.iconBabyBoy,
                          color: Colors.lightBlue[100]!,
                          gender: 'Boy',
                          controller: _confettiControllerBoy),
                      _buildGenderCard(
                          label: 'Girl',
                          assetPath: AssetConstant.iconBabyGirl,
                          color: Colors.pink[100]!,
                          gender: 'Girl',
                          controller: _confettiControllerGirl),
                      _buildGenderCard(
                          label: 'Any',
                          assetPath: AssetConstant.iconBabyAny,
                          color: Colors.yellow[100]!,
                          gender: 'Any',
                          controller: _confettiControllerAny),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedGender != null) {
                    _navigateToNext();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please select one and continue'),
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
          ],
        ),
      ),
    );
  }

  Future<void> _saveSelectedGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefConstants.gender, gender);
    if (gender == 'boy') {
      _confettiControllerBoy.play();
    } else if (gender == 'girl') {
      _confettiControllerGirl.play();
    } else if (gender == 'any') {
      _confettiControllerAny.play();
    }
    setState(() {
      _selectedGender = gender;
    });
  }

  Future<void> _loadSelectedGender() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedGender = prefs.getString(SharedPrefConstants.gender);
    });
  }

  void _onCardTap(String gender) {
    _saveSelectedGender(gender);
    // _navigateToNext();
  }

  Widget _buildGenderCard(
      {required String label,
      required String assetPath,
      required Color color,
      required String gender,
      required ConfettiController controller}) {
    return GestureDetector(
      onTap: () => _onCardTap(gender),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(assetPath, width: 50, height: 50),
                      SizedBox(height: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ConfettiWidget(
                  confettiController: controller,
                  numberOfParticles: 50,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: [
                    Colors.purple.shade100,
                    Colors.red.shade100,
                    Colors.blue.shade400,
                    Colors.green.shade400,
                    Colors.green.shade100,
                    Colors.cyan.shade700,
                    Colors.redAccent,
                    Colors.orange,
                  ],
                )
              ],
            ),
          ),
          if (_selectedGender == gender)
            const Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToNext() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_selectedGender == "boy") {
        GetIt.instance<ThemeCubit>().updateTheme(BoyColorPalette());
      } else if (_selectedGender == "girl") {
        GetIt.instance<ThemeCubit>().updateTheme(GirlColorPalette());
      }
      SharedPreferences.getInstance().then((pref) {
        pref.setInt(SharedPrefConstants.setupSteps, SetupSteps.name);
      });
      GetIt.instance<GoRouter>().go(RoutePath.babyName);
    });
  }
}
