import 'package:flutter/material.dart';

/// Shadow Definitions for Elevation & Glow Effects
class AppShadows {
  static const List<BoxShadow> darkCard = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> darkGlowBlue = [
    BoxShadow(
      color: Color(0x402979FF),
      offset: Offset(0, 4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> darkGlowCyan = [
    BoxShadow(
      color: Color(0x3300E5FF),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 1,
    ),
  ];

  static const List<BoxShadow> lightCard = [
    BoxShadow(
      color: Color(0x060F172A),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A0F172A),
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}

