import 'package:flutter/material.dart';

class AqiPollutant {
  final String name; // PM2.5, PM10, O3, NO2, SO2, CO
  final double value;
  final String unit; // µg/m³
  final String status; // Good, Moderate, Poor, etc.
  final Color statusColor;

  const AqiPollutant({
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    required this.statusColor,
  });
}

class PollenItem {
  final String type; // Tree, Grass, Weed
  final String level; // Low, Moderate, High, Very High
  final int count; // grains/m3
  final Color levelColor;

  const PollenItem({
    required this.type,
    required this.level,
    required this.count,
    required this.levelColor,
  });
}

class HealthData {
  final int aqi;
  final String aqiCategory;
  final Color aqiColor;
  final String generalRecommendation;
  final List<AqiPollutant> pollutants;
  final List<PollenItem> pollenLevels;
  final int uvIndex;
  final String uvCategory;
  final String uvAdvice;
  final int humidity;
  final String humidityImpact;
  final String environmentalRisk; // Low, Moderate, High
  final List<String> sensitiveGroupAdvisories;
  final bool isMockData;

  const HealthData({
    required this.aqi,
    required this.aqiCategory,
    required this.aqiColor,
    required this.generalRecommendation,
    required this.pollutants,
    required this.pollenLevels,
    required this.uvIndex,
    required this.uvCategory,
    required this.uvAdvice,
    required this.humidity,
    required this.humidityImpact,
    required this.environmentalRisk,
    required this.sensitiveGroupAdvisories,
    this.isMockData = false,
  });
}
