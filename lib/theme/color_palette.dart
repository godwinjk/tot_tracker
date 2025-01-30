import 'package:flutter/material.dart';

abstract class ColorPalette {
  // Common color properties
  Color get primary;

  Color get secondary;

  Color get accent;

  Color get appBarBackground;

  Color get bottomNavBackground;

  Color get textColor;

  Color get buttonColor;

  // Dark mode properties
  Color get darkPrimary;

  Color get darkSecondary;

  Color get darkAccent;

  Color get darkAppBarBackground;

  Color get darkBottomNavBackground;

  Color get darkTextColor;

  Color get darkButtonColor;
}

// Boy Color Palette
class BoyColorPalette extends ColorPalette {
  @override
  Color get primary => const Color(0xFFBBDEFB); // Baby Blue
  @override
  Color get secondary => const Color(0xFF2FA193); // Light Teal
  @override
  Color get accent => const Color(0xFFFFEB3B); // Soft Yellow
  @override
  Color get appBarBackground => const Color(0xFF0288D1); // Deep Blue
  @override
  Color get bottomNavBackground => const Color(0xFFE1F5FE); // Light Blue
  @override
  Color get textColor => const Color(0xFF455A64); // Dark Gray
  @override
  Color get buttonColor => const Color(0xFF81D4FA); // Soft Blue

  @override
  Color get darkPrimary => const Color(0xFF64B5F6); // Muted Blue
  @override
  Color get darkSecondary => const Color(0xFF4FC3F7); // Muted Teal
  @override
  Color get darkAccent => const Color(0xFFFFD54F); // Muted Yellow
  @override
  Color get darkAppBarBackground => const Color(0xFF37474F); // Dark Blue Gray
  @override
  Color get darkBottomNavBackground =>
      const Color(0xFF263238); // Dark Slate Gray
  @override
  Color get darkTextColor => const Color(0xFFB0BEC5); // Light Gray
  @override
  Color get darkButtonColor => const Color(0xFF254865); // Light Blue
}

// Girl Color Palette
class GirlColorPalette extends ColorPalette {
  @override
  Color get primary => const Color(0xFFF8BBD0); // Soft Pink
  @override
  Color get secondary => const Color(0xFF9D68A5); // Lavender
  @override
  Color get accent => const Color(0xFFFFCDD2); // Light Coral
  @override
  Color get appBarBackground => const Color(0xFFD81B60); // Deep Pink
  @override
  Color get bottomNavBackground => const Color(0xFFFFF8E1); // Light Cream
  @override
  Color get textColor => const Color(0xFF273237); // Dark Gray
  @override
  Color get buttonColor => const Color(0xFFF675A1); // Bright Pink

  @override
  Color get darkPrimary => const Color(0xFFF48FB1); // Muted Pink
  @override
  Color get darkSecondary => const Color(0xFFCE93D8); // Muted Lavender
  @override
  Color get darkAccent => const Color(0xFFFFAB91); // Muted Coral
  @override
  Color get darkAppBarBackground => const Color(0xFF880E4F); // Deep Dark Pink
  @override
  Color get darkBottomNavBackground => const Color(0xFF424242); // Dark Gray
  @override
  Color get darkTextColor => const Color(0xFFB0BEC5); // Light Gray
  @override
  Color get darkButtonColor => const Color(0xFF732C44); // Light Pink
}

// Neutral Color Palette
class NeutralColorPalette extends ColorPalette {
  @override
  Color get primary => const Color(0xFFFFEB3B); // Soft Yellow
  @override
  Color get secondary => const Color(0xFFAED581); // Mint Green
  @override
  Color get accent => const Color(0xFFFFF59D); // Light Yellow
  @override
  Color get appBarBackground => const Color(0xFFCDDC39); // Lime Green
  @override
  Color get bottomNavBackground => const Color(0xFFFFFDE7); // Cream
  @override
  Color get textColor => const Color(0xFF21292E); // Dark Gray
  @override
  Color get buttonColor => const Color(0xFFFDD835); // Bright Yellow

  @override
  Color get darkPrimary => const Color(0xFFFBC02D); // Muted Yellow
  @override
  Color get darkSecondary => const Color(0xFF8BC34A); // Muted Green
  @override
  Color get darkAccent => const Color(0xFFFFD740); // Muted Bright Yellow
  @override
  Color get darkAppBarBackground => const Color(0xFF37474F); // Dark Gray
  @override
  Color get darkBottomNavBackground =>
      const Color(0xFF263238); // Dark Slate Gray
  @override
  Color get darkTextColor => const Color(0xFFB0BEC5); // Light Gray
  @override
  Color get darkButtonColor => const Color(0xFF70601E); // Muted Yellow
}
