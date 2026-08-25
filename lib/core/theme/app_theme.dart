import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

/// AppTheme definition for Dark and Light modes
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        onPrimary: Colors.white,
        secondary: AppColors.accentCyan,
        onSecondary: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.textDarkPrimary,
        error: AppColors.statusDanger,
        onError: Colors.white,
        outline: AppColors.darkBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.textDarkPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textDarkPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLg,
          side: BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDarkPrimary,
          side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.textDarkMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide:
              BorderSide(color: AppColors.primaryBlue, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.statusDanger),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackgroundSecondary,
        selectedItemColor: AppColors.accentCyan,
        unselectedItemColor: AppColors.textDarkMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorderSubtle,
        thickness: 1,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        onPrimary: Colors.white,
        secondary: AppColors.accentCyan,
        onSecondary: Colors.black,
        surface: AppColors.lightSurface,
        onSurface: AppColors.textLightPrimary,
        error: AppColors.statusDanger,
        onError: Colors.white,
        outline: AppColors.lightBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.textLightPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.textLightPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLg,
          side: BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textLightPrimary,
          side: const BorderSide(color: AppColors.lightBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        hintStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.textLightMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide:
              BorderSide(color: AppColors.primaryBlue, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.statusDanger),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textLightMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorderSubtle,
        thickness: 1,
      ),
    );
  }
}
