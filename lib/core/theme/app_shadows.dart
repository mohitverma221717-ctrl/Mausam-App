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
      color: Color(0x0F0A0E17),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Color(0x66000000),
      offset: Offset(0, -4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
}
