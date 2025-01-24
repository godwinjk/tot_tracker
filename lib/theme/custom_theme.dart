import 'package:flutter/material.dart';

import 'color_palette.dart';

ThemeData createTheme(ColorPalette palette, {bool isDarkMode = false}) {
  return ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: isDarkMode ? palette.darkPrimary : palette.primary,
    scaffoldBackgroundColor: isDarkMode
        ? palette.darkBottomNavBackground
        : palette.bottomNavBackground,
    appBarTheme: AppBarTheme(
      backgroundColor:
          isDarkMode ? palette.darkAppBarBackground : palette.appBarBackground,
      titleTextStyle: TextStyle(
        color: isDarkMode ? palette.darkTextColor : palette.textColor,
        fontSize: 20.0,
        fontFamily: 'Comfortaa',
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: isDarkMode ? palette.darkTextColor : palette.textColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: isDarkMode
          ? palette.darkBottomNavBackground
          : palette.bottomNavBackground,
      selectedItemColor: isDarkMode ? palette.darkSecondary : palette.secondary,
      unselectedItemColor:
          isDarkMode ? palette.darkTextColor : palette.textColor,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: isDarkMode ? palette.darkTextColor : palette.textColor,
        fontSize: 16.0,
        fontFamily: 'Comfortaa',
      ),
      headlineSmall: TextStyle(
        color: isDarkMode ? palette.darkTextColor : palette.textColor,
        fontSize: 24.0,
        fontFamily: 'Comfortaa',
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isDarkMode ? palette.darkButtonColor : palette.buttonColor,
        foregroundColor: isDarkMode ? palette.darkTextColor : palette.textColor,
      ),
    ),
  );
}
