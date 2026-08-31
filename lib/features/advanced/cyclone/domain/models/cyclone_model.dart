import 'package:flutter/material.dart';

class CyclonePosition {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double windSpeedKmh;
  final double pressureHpa;

  const CyclonePosition({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.windSpeedKmh,
    required this.pressureHpa,
  });
}

class CycloneForecastPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double expectedWindSpeedKmh;
  final String intensityCategory;

  const CycloneForecastPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.expectedWindSpeedKmh,
    required this.intensityCategory,
  });
}

class Cyclone {
  final String id;
  final String name;
  final String oceanBasin;
  final String category; // e.g. "Severe Cyclonic Storm", "Category 3"
  final CyclonePosition currentPosition;
  final List<CyclonePosition> observedTrack;
  final List<CycloneForecastPoint> forecastPath;
  final String movementDirection;
  final double movementSpeedKmh;
  final String expectedLandfallTime;
  final String expectedLandfallLocation;
  final List<String> affectedRegions;
  final String source;
  final DateTime lastUpdated;

  const Cyclone({
    required this.id,
    required this.name,
    required this.oceanBasin,
    required this.category,
    required this.currentPosition,
    required this.observedTrack,
    required this.forecastPath,
    required this.movementDirection,
    required this.movementSpeedKmh,
    required this.expectedLandfallTime,
    required this.expectedLandfallLocation,
    required this.affectedRegions,
    required this.source,
    required this.lastUpdated,
  });

  Color get categoryColor {
    if (category.contains('Very Severe') ||
        category.contains('Category 4') ||
        category.contains('Category 5')) {
      return const Color(0xFFDC2626);
    } else if (category.contains('Severe') || category.contains('Category 3')) {
      return const Color(0xFFEF4444);
    } else if (category.contains('Cyclonic Storm') ||
        category.contains('Category 1') ||
        category.contains('Category 2')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF3B82F6);
  }
}
