import 'package:flutter/material.dart';

enum NotificationCategory {
  rain,
  cyclone,
  earthquake,
  lightning,
  heatwave,
  flood,
  health,
  travel,
  commute,
  event,
}

enum NotificationPriority {
  low,
  medium,
  high,
  critical,
}

class MausamNotification {
  final String id;
  final NotificationCategory category;
  final String title;
  final String body;
  final NotificationPriority priority;
  final DateTime timestamp;
  final String location;
  final String source;

  const MausamNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.priority,
    required this.timestamp,
    required this.location,
    required this.source,
  });
}

class SmartNotificationEngine {
  final Set<String> _suppressedIds = {};
  bool quietHoursEnabled = false;
  TimeOfDay quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay quietEnd = const TimeOfDay(hour: 7, minute: 0);

  bool shouldDeliverNotification(MausamNotification notification) {
    // 1. Duplicate suppression
    if (_suppressedIds.contains(notification.id)) {
      return false;
    }

    // 2. Quiet Hours check (Critical notifications bypass quiet hours)
    if (quietHoursEnabled &&
        notification.priority != NotificationPriority.critical) {
      final now = TimeOfDay.now();
      if (_isInQuietHours(now)) {
        return false;
      }
    }

    _suppressedIds.add(notification.id);
    return true;
  }

  bool _isInQuietHours(TimeOfDay now) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = quietStart.hour * 60 + quietStart.minute;
    final endMinutes = quietEnd.hour * 60 + quietEnd.minute;

    if (startMinutes > endMinutes) {
      return nowMinutes >= startMinutes || nowMinutes <= endMinutes;
    }
    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }
}
