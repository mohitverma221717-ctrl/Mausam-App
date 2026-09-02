import 'package:flutter/material.dart';

/// Centralized Color Tokens for MAUSAM App
/// Designed around a premium Dark Theme (Deep Navy, Electric Blue, Cyan)
/// and a refined Light Theme.
class AppColors {
  // Dark Palette (Deep Midnight Navy - Reference Inspiration)
  static const Color darkBackground = Color(0xFF050B16);
  static const Color darkBackgroundSecondary = Color(0xFF07111F);
  static const Color darkSurface = Color(0xFF0B1B2D);
  static const Color darkSurfaceElevated = Color(0xFF102741);
  static const Color darkSurfaceCard = Color(0xFF0D2138);
  static const Color darkBorder = Color(0x267DD3FC); // Subtle cyan-navy translucent border
  static const Color darkBorderSubtle = Color(0x1A7DD3FC);

  // Light Palette
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightBackgroundSecondary = Color(0xFFEFF3F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF8FAFC);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFFF1F5F9);

  // Soft Tint Pill & Icon Backgrounds (Light Mode)
  static const Color greenTintBg = Color(0xFFE6F4EA);
  static const Color greenTintText = Color(0xFF137333);
  static const Color amberTintBg = Color(0xFFFEF3C7);
  static const Color amberTintText = Color(0xFFB45309);
  static const Color redTintBg = Color(0xFFFCE8E6);
  static const Color redTintText = Color(0xFFC5221F);
  static const Color blueTintBg = Color(0xFFE8F0FE);
  static const Color blueTintText = Color(0xFF1A73E8);

  // Brand Accents & Weather Palette
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFF60A5FA);
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentCyanGlow = Color(0xFF7DD3FC);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentPurple = Color(0xFF8B5CF6);

  // Text Colors - Dark Mode
  static const Color textDarkPrimary = Color(0xFFF1F5F9);
  static const Color textDarkSecondary = Color(0xFFB8C4D2);
  static const Color textDarkMuted = Color(0xFF8190A5);
  static const Color textDarkDisabled = Color(0xFF475569);

  // Convenient Aliases
  static const Color cyanAccent = Color(0xFF38BDF8);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFFB8C4D2);
  static const Color textMuted = Color(0xFF8190A5);
  static const Color glassBorder = Color(0x267DD3FC);

  // Text Colors - Light Mode
  static const Color textLightPrimary = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF475569);
  static const Color textLightMuted = Color(0xFF64748B);
  static const Color textLightDisabled = Color(0xFF94A3B8);

  // Status & Severity Colors
  static const Color statusSuccess = Color(0xFF10B981); // Good / Normal
  static const Color statusSuccessLight = Color(0xFF059669);
  static const Color statusWarning = Color(0xFFF59E0B); // Moderate
  static const Color statusWarningLight = Color(0xFFD97706);
  static const Color statusDanger = Color(0xFFEF4444); // Unhealthy / High
  static const Color statusDangerDark = Color(0xFFDC2626);
  static const Color statusExtreme = Color(0xFF8B5CF6); // Hazardous / Extreme
  static const Color statusInfo = Color(0xFF0284C7);

  // Weather Condition Gradients
  static const LinearGradient sunnyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static const LinearGradient nightClearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF050B16), Color(0xFF102741)],
  );

  static const LinearGradient rainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D2138), Color(0xFF1E3A8A)],
  );

  static const LinearGradient stormyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF091322), Color(0xFF163554)],
  );

  static const LinearGradient aqiGoodGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF0284C7)],
  );

  static const LinearGradient electricBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF38BDF8)],
  );

  static const LinearGradient cardDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1B2D), Color(0xFF102741)],
  );
}

