import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/di/injection_base.dart';

import '../persistence/shared_pref_const.dart';
import 'color_palette.dart';
import 'custom_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit(ColorPalette initialPalette, {bool isDarkMode = false})
      : super(createTheme(initialPalette, isDarkMode: isDarkMode));

  // Method to fetch system brightness

  late bool isDarkMode = false;

  void updateTheme(ColorPalette palette, {bool isDarkMode = false}) {
    emit(createTheme(palette, isDarkMode: isDarkMode));
    setColorPalette(palette);
  }

  void toggleDarkMode(ColorPalette currentPalette, bool isDarkMode) {
    emit(createTheme(currentPalette, isDarkMode: isDarkMode));
  }

  void setGenderBasedTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SharedPreferences.getInstance().then((value) {
      final gender = value.getString(SharedPrefConstants.gender) ?? '';
      if (gender == "boy") {
        updateTheme(BoyColorPalette(), isDarkMode: isDark);
      } else if (gender == "girl") {
        updateTheme(GirlColorPalette(), isDarkMode: isDark);
      }
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
