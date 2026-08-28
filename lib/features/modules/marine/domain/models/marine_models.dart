import 'package:flutter/material.dart';

class TideEvent {
  final String time; // "5:30 PM"
  final String type; // "High Tide", "Low Tide"
  final double heightMeters; // 2.4 m
  final bool isHigh;

  const TideEvent({
    required this.time,
    required this.type,
    required this.heightMeters,
    required this.isHigh,
  });
}

class MarineData {
  final String seaCondition; // "Good", "Moderate", "Rough"
  final Color conditionColor;
  final double waveHeight; // 1.2 m
  final double wavePeriodSeconds; // 8.5 s
  final double waterTemp; // 28°C
  final double windSpeedKnots; // 18 knots (or km/h)
  final String windDirection; // "NW"
  final String swellDirection; // "WSW"
  final List<TideEvent> tides;
  final String boatingSafety; // "Safe for recreational boating"
  final String surfQuality; // "Clean 3-4 ft peelers"
  final bool isMockData;

  const MarineData({
    required this.seaCondition,
    required this.conditionColor,
    required this.waveHeight,
    required this.wavePeriodSeconds,
    required this.waterTemp,
    required this.windSpeedKnots,
    required this.windDirection,
    required this.swellDirection,
    required this.tides,
    required this.boatingSafety,
    required this.surfQuality,
    this.isMockData = true,
  });
}
