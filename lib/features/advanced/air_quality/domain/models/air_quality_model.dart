import 'package:flutter/material.dart';

class AirQualityData {
  final int aqi;
  final double pm25;
  final double pm10;
  final double no2;
  final double o3;
  final String
      category; // Good, Moderate, Unhealthy for Sensitive, Unhealthy, Very Unhealthy, Hazardous
  final String healthAdvice;
  final String source;
  final DateTime lastUpdated;

  const AirQualityData({
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.o3,
    required this.category,
    required this.healthAdvice,
    required this.source,
    required this.lastUpdated,
  });

  Color get categoryColor {
    if (aqi <= 50) return const Color(0xFF10B981);
    if (aqi <= 100) return const Color(0xFFF59E0B);
    if (aqi <= 150) return const Color(0xFFF97316);
    if (aqi <= 200) return const Color(0xFFEF4444);
    if (aqi <= 300) return const Color(0xFFA855F7);
    return const Color(0xFF881337);
  }
}
