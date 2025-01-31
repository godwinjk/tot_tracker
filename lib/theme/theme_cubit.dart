import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/di/injection_base.dart';

import '../persistence/shared_pref_const.dart';
import 'color_palette.dart';
import 'custom_theme.dart';

class ThemeCubit extends Cubit<ThemeLoaded> {
  ThemeCubit(ColorPalette initialPalette, {bool isDarkMode = false})
      : super(ThemeLoaded(
            lightTheme: createTheme(initialPalette, isDarkMode: false),
            darkTheme: createTheme(initialPalette, isDarkMode: true)));

  // Method to fetch system brightness

  late bool isDarkMode = false;

  void updateTheme(ColorPalette palette) {
    emit(ThemeLoaded(
        lightTheme: createTheme(palette, isDarkMode: false),
        darkTheme: createTheme(palette, isDarkMode: true)));
    setColorPalette(palette);
  }

  void toggleDarkMode(ColorPalette currentPalette, bool isDarkMode) {
    emit(ThemeLoaded(
        lightTheme: createTheme(currentPalette, isDarkMode: isDarkMode),
        darkTheme: createTheme(currentPalette, isDarkMode: isDarkMode)));
  }

  void setGenderBasedTheme() {
    SharedPreferences.getInstance().then((value) {
      final gender = value.getString(SharedPrefConstants.gender) ?? '';
      if (gender == "Boy") {
        updateTheme(BoyColorPalette());
      } else if (gender == "Girl") {
        updateTheme(GirlColorPalette());
      } else {
        updateTheme(NeutralColorPalette());
      }
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

class ThemeLoaded {
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  ThemeLoaded({required this.lightTheme, required this.darkTheme});
}
