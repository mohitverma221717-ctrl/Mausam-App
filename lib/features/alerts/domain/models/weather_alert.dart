import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum AlertSeverity {
  info,
  low,
  moderate,
  high,
  extreme,
}

extension AlertSeverityX on AlertSeverity {
  String get displayName {
    switch (this) {
      case AlertSeverity.info:
        return 'Info';
      case AlertSeverity.low:
        return 'Low';
      case AlertSeverity.moderate:
        return 'Moderate';
      case AlertSeverity.high:
        return 'High';
      case AlertSeverity.extreme:
        return 'Extreme';
    }
  }

  Color get color {
    switch (this) {
      case AlertSeverity.info:
        return AppColors.statusInfo;
      case AlertSeverity.low:
        return AppColors.statusSuccess;
      case AlertSeverity.moderate:
        return AppColors.statusWarning;
      case AlertSeverity.high:
        return AppColors.statusDanger;
      case AlertSeverity.extreme:
        return AppColors.statusExtreme;
    }
  }
}

class WeatherAlert {
  final String id;
  final String title;
  final String type; // e.g. "Heavy Rain", "Heat Wave", "Fog Alert"
  final AlertSeverity severity;
  final String location;
  final String description;
  final String advisory;
  final String timeRange; // e.g. "Expected 8:00 PM – 11:00 PM"
  final DateTime startTime;
  final DateTime endTime;
  final String source; // e.g. "India Meteorological Department"
  final bool isRead;

  const WeatherAlert({
    required this.id,
    required this.title,
    required this.type,
    required this.severity,
    required this.location,
    required this.description,
    required this.advisory,
    required this.timeRange,
    required this.startTime,
    required this.endTime,
    required this.source,
    this.isRead = false,
  });

  WeatherAlert copyWith({bool? isRead}) {
    return WeatherAlert(
      id: id,
      title: title,
      type: type,
      severity: severity,
      location: location,
      description: description,
      advisory: advisory,
      timeRange: timeRange,
      startTime: startTime,
      endTime: endTime,
      source: source,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String category;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.category,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      category: category,
      isRead: isRead ?? this.isRead,
    );
  }
}
