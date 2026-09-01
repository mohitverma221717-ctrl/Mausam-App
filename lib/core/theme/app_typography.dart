import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized Typography Hierarchy for MAUSAM App
class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 54,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.15,
      );

  static TextStyle get displaySmall => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.35,
      );

  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.4,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      );

  // Weather & Hero Display Serif Styles (Matching design reference)
  static TextStyle get serifHeroTemperature => GoogleFonts.newsreader(
        fontSize: 72,
        fontWeight: FontWeight.w500,
        letterSpacing: -1.0,
        height: 1.0,
      );

  static TextStyle get serifHeader => GoogleFonts.newsreader(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get serifTitle => GoogleFonts.newsreader(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      );

  static TextStyle get serifMetricValue => GoogleFonts.newsreader(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  // Weather Metric Specific Styles
  static TextStyle get temperatureHero => serifHeroTemperature;

  static TextStyle get temperatureCard => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get metricValue => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      );

  static TextStyle get metricLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: AppColors.textDarkSecondary,
      );
}

