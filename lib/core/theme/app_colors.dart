import 'package:flutter/material.dart';

/// Centralized Color Tokens for MAUSAM App
/// Designed around a premium Dark Theme (Deep Navy, Electric Blue, Cyan)
/// and a refined Light Theme.
class AppColors {
  // Dark Palette (Primary / Default)
  static const Color darkBackground = Color(0xFF0A0E17);
  static const Color darkBackgroundSecondary = Color(0xFF0D1424);
  static const Color darkSurface = Color(0xFF131B2E);
  static const Color darkSurfaceElevated = Color(0xFF1A243D);
  static const Color darkSurfaceCard = Color(0xFF151F36);
  static const Color darkBorder = Color(0xFF1E2C4A);
  static const Color darkBorderSubtle = Color(0xFF18233A);

  // Light Palette
  static const Color lightBackground = Color(0xFFF4F7FC);
  static const Color lightBackgroundSecondary = Color(0xFFE9F0FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF8FAFD);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFD6E2F0);
  static const Color lightBorderSubtle = Color(0xFFE4EDF7);

  // Brand Accents
  static const Color primaryBlue = Color(0xFF2979FF);
  static const Color primaryBlueDark = Color(0xFF0052CC);
  static const Color primaryBlueLight = Color(0xFF5393FF);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentCyanGlow = Color(0xFF18FFFF);
  static const Color accentIndigo = Color(0xFF5C6BC0);
  static const Color accentPurple = Color(0xFF7C4DFF);

  // Text Colors - Dark Mode
  static const Color textDarkPrimary = Color(0xFFFFFFFF);
  static const Color textDarkSecondary = Color(0xFF94A3B8);
  static const Color textDarkMuted = Color(0xFF64748B);
  static const Color textDarkDisabled = Color(0xFF475569);

  // Text Colors - Light Mode
  static const Color textLightPrimary = Color(0xFF0A0E17);
  static const Color textLightSecondary = Color(0xFF475569);
  static const Color textLightMuted = Color(0xFF94A3B8);
  static const Color textLightDisabled = Color(0xFFCBD5E1);

  // Status & Severity Colors
  static const Color statusSuccess = Color(0xFF00E676); // Good / Normal
  static const Color statusSuccessLight = Color(0xFF00C853);
  static const Color statusWarning = Color(0xFFFFB300); // Moderate
  static const Color statusWarningLight = Color(0xFFFFA000);
  static const Color statusDanger = Color(0xFFFF3D71); // Unhealthy / High
  static const Color statusDangerDark = Color(0xFFD50000);
  static const Color statusExtreme = Color(0xFF9C27B0); // Hazardous / Extreme
  static const Color statusInfo = Color(0xFF00B0FF);

  // Weather Condition Gradients
  static const LinearGradient sunnyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9100), Color(0xFFFF3D00)],
  );

  static const LinearGradient nightClearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1424), Color(0xFF1E2C4A)],
  );

  static const LinearGradient rainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2A44), Color(0xFF0052CC)],
  );

  static const LinearGradient stormyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF141923), Color(0xFF37474F)],
  );

  static const LinearGradient aqiGoodGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
  );

  static const LinearGradient electricBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2979FF), Color(0xFF00E5FF)],
  );

  static const LinearGradient cardDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF162035), Color(0xFF101726)],
  );
}
