import 'package:flutter/material.dart';

class EarthquakeEvent {
  final String id;
  final double magnitude;
  final double latitude;
  final double longitude;
  final double depthKm;
  final String place;
  final DateTime timestamp;
  final String source;
  final double distanceKm;

  const EarthquakeEvent({
    required this.id,
    required this.magnitude,
    required this.latitude,
    required this.longitude,
    required this.depthKm,
    required this.place,
    required this.timestamp,
    required this.source,
    required this.distanceKm,
  });

  Color get magnitudeColor {
    if (magnitude >= 7.0) return const Color(0xFFDC2626); // Major
    if (magnitude >= 5.5) return const Color(0xFFEF4444); // Strong
    if (magnitude >= 4.0) return const Color(0xFFF59E0B); // Moderate
    return const Color(0xFF10B981); // Minor
  }

  String get intensityLabel {
    if (magnitude >= 7.0) return 'Severe / Major';
    if (magnitude >= 5.5) return 'Strong';
    if (magnitude >= 4.0) return 'Moderate';
    return 'Minor';
  }
}
