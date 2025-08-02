// # File: frontend/lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors - Vibrant and child-friendly
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryRed = Color(0xFFF44336);
  static const Color primaryYellow = Color(0xFFFFEB3B);

  // Gamification Colors
  static const Color knowledgeGems = Color(0xFF2196F3);
  static const Color wordCoins = Color(0xFFFFD700);
  static const Color imaginationSparks = Color(0xFFE91E63);
  static const Color achievementGold = Color(0xFFFFC107);

  // Background Colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF1A1A2E);

  // Text Colors
  static const Color primaryText = Color(0xFF2D3748);
  static const Color secondaryText = Color(0xFF718096);
  static const Color lightText = Color(0xFFFFFFFF);

  // Success/Warning/Error Colors
  static const Color successGreen = Color(0xFF48BB78);
  static const Color warningOrange = Color(0xFFED8936);
  static const Color errorRed = Color(0xFFF56565);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];

  static const List<Color> secondaryGradient = [
    Color(0XFFf093fb),
    Color(0XFFf5576c),
  ];

  static const List<Color> successGradient = [
    Color(0xFF11998e),
    Color(0xFF38ef7d),
  ];

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: primaryBlue,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryPurple,
        tertiary: primaryOrange,
        surface: cardBackground,
        background: lightBackground,
        error: errorRed,
        onPrimary: lightText,
        onSecondary: lightText,
        onSurface: primaryText,
        onBackground: primaryText,
        onError: lightText,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: primaryText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
        iconTheme: const IconThemeData(
          color: primaryText,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: lightText,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryOrange,
        foregroundColor: lightText,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: GoogleFonts.comicNeue(
          fontSize: 16,
          color: secondaryText,
        ),
        hintStyle: GoogleFonts.comicNeue(
          fontSize: 14,
          color: secondaryText,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.fredoka(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        headlineMedium: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        headlineSmall: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
        titleMedium: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
        titleSmall: GoogleFonts.fredoka(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
        bodyLarge: GoogleFonts.comicNeue(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: primaryText,
        ),
        bodyMedium: GoogleFonts.comicNeue(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: primaryText,
        ),
        bodySmall: GoogleFonts.comicNeue(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: secondaryText,
        ),
        labelLarge: GoogleFonts.comicNeue(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
        labelMedium: GoogleFonts.comicNeue(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: secondaryText,
        ),
        labelSmall: GoogleFonts.comicNeue(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: secondaryText,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: primaryBlue,
        unselectedItemColor: secondaryText,
        selectedLabelStyle: GoogleFonts.fredoka(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.fredoka(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: lightBackground,
        selectedColor: primaryBlue,
        disabledColor: Colors.grey.shade300,
        deleteIconColor: primaryText,
        labelStyle: GoogleFonts.comicNeue(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: Color(0xFFE0E0E0),
        circularTrackColor: Color(0xFFE0E0E0),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryText,
        contentTextStyle: GoogleFonts.comicNeue(
          fontSize: 14,
          color: lightText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dark Theme (simplified for children - mainly for parents/teachers)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: primaryPurple,
        tertiary: primaryOrange,
        surface: Color(0xFF1E1E2E),
        background: darkBackground,
        error: errorRed,
        onPrimary: lightText,
        onSecondary: lightText,
        onSurface: lightText,
        onBackground: lightText,
        onError: lightText,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.fredoka(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightText,
        ),
        headlineMedium: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightText,
        ),
        bodyLarge: GoogleFonts.comicNeue(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: lightText,
        ),
      ),
    );
  }
}

// Custom widget extensions for theming
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
