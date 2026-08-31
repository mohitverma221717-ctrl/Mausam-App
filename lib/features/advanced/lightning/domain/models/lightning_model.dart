import 'package:flutter/material.dart';

class LightningActivity {
  final String location;
  final int strikeCountLastHour;
  final double nearestStrikeKm;
  final String densityLevel; // Low, Moderate, High, Severe
  final int activeStormCells;
  final DateTime lastStrikeTimestamp;
  final String source;

  const LightningActivity({
    required this.location,
    required this.strikeCountLastHour,
    required this.nearestStrikeKm,
    required this.densityLevel,
    required this.activeStormCells,
    required this.lastStrikeTimestamp,
    required this.source,
  });

  Color get statusColor {
    switch (densityLevel.toLowerCase()) {
      case 'severe':
        return const Color(0xFFDC2626);
      case 'high':
        return const Color(0xFFEF4444);
      case 'moderate':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }
}
