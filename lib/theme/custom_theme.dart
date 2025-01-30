import 'package:flutter/material.dart';

import 'card_color_theme.dart';
import 'color_palette.dart';

ThemeData createTheme(ColorPalette palette, {bool isDarkMode = false}) {
  return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: isDarkMode ? palette.darkPrimary : palette.primary,
      scaffoldBackgroundColor: isDarkMode
          ? palette.darkBottomNavBackground
          : palette.bottomNavBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode
            ? palette.darkAppBarBackground
            : palette.appBarBackground,
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
        selectedItemColor:
            isDarkMode ? palette.darkSecondary : palette.secondary,
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
          foregroundColor:
              isDarkMode ? palette.darkTextColor : palette.textColor,
        ),
      ),
      extensions: [
        CardColorTheme(
            cardColors: isDarkMode
                ? [
                    Colors.pink.shade900,
                    Colors.brown.shade900,
                    Colors.blue.shade900,
                    Colors.green.shade900,
                    Colors.yellow.shade900,
                    Colors.blueGrey.shade900,
                    Colors.deepPurple.shade900,
                  ]
                : [
                    Colors.pink.shade200,
                    Colors.brown.shade200,
                    Colors.blue.shade200,
                    Colors.green.shade200,
                    Colors.yellow.shade200,
                    Colors.blueGrey.shade200,
                    Colors.deepPurple.shade200,
                  ])
      ]);
}
