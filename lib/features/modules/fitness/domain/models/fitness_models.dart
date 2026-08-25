import 'package:flutter/material.dart';

class RunningWindow {
  final String timeRange; // e.g. "6:00 AM – 8:00 AM"
  final String quality; // "Optimal", "Good", "Fair", "Avoid"
  final Color qualityColor;
  final double temp;
  final int humidity;
  final double wind;
  final String note;

  const RunningWindow({
    required this.timeRange,
    required this.quality,
    required this.qualityColor,
    required this.temp,
    required this.humidity,
    required this.wind,
    required this.note,
  });
}

class FitnessData {
  final String bestRunningHours; // "6:00 AM – 8:00 AM"
  final String overallSuitability; // "Good Conditions"
  final String
      activitySuggestion; // "Perfect time for running and outdoor workouts."
  final double heatIndex; // 31°C
  final String heatRisk; // "Low Risk"
  final int uvIndex;
  final double windSpeed;
  final int humidity;
  final double currentTemp;
  final List<RunningWindow> hourlyWindows;
  final Map<String, String>
      activityRatings; // Running: Great, Cycling: Good, Swimming: Excellent

  const FitnessData({
    required this.bestRunningHours,
    required this.overallSuitability,
    required this.activitySuggestion,
    required this.heatIndex,
    required this.heatRisk,
    required this.uvIndex,
    required this.windSpeed,
    required this.humidity,
    required this.currentTemp,
    required this.hourlyWindows,
    required this.activityRatings,
  });
}
