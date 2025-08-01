import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6E4F9B);
const Color accentColor = Color(0xFFF5D7E3);
const Color backgroundColor = Color(0xFF1A1A1A);
const Color cardColor = Color(0xFF2C2C2C);
const Color textColor = Colors.white;

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: accentColor,
    surface: cardColor,
    onPrimary: textColor,
    onSecondary: Colors.black,
    onSurface: textColor,
  ),
  scaffoldBackgroundColor: backgroundColor,
  cardColor: cardColor,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: textColor),
    displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
    bodyLarge: TextStyle(fontSize: 16.0, color: textColor),
    bodyMedium: TextStyle(fontSize: 14.0, color: textColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: accentColor),
    ),
    labelStyle: const TextStyle(color: textColor),
  ),
);
