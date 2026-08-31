import 'package:flutter/material.dart';

class EventPlanReport {
  final String eventName;
  final String location;
  final DateTime eventDate;
  final String timeRange;
  final bool isOutdoor;
  final double tempMin;
  final double tempMax;
  final int rainProbability;
  final double windSpeedKmh;
  final int humidity;
  final String
      suitabilityRating; // Highly Favorable, Moderate Risk, Unfavorable
  final String summaryExplanation;
  final String disclaimer;

  const EventPlanReport({
    required this.eventName,
    required this.location,
    required this.eventDate,
    required this.timeRange,
    required this.isOutdoor,
    required this.tempMin,
    required this.tempMax,
    required this.rainProbability,
    required this.windSpeedKmh,
    required this.humidity,
    required this.suitabilityRating,
    required this.summaryExplanation,
    required this.disclaimer,
  });

  Color get ratingColor {
    switch (suitabilityRating.toLowerCase()) {
      case 'highly favorable':
        return const Color(0xFF10B981);
      case 'moderate risk':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }
}
