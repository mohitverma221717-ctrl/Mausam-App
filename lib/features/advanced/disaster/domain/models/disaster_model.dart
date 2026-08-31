import 'package:flutter/material.dart';

enum DisasterType {
  cyclone,
  flood,
  heavyRain,
  heatwave,
  lightning,
  thunderstorm,
  earthquake,
  fog,
  coldWave,
  landslide,
}

enum DisasterSeverity {
  info,
  low,
  moderate,
  high,
  extreme,
}

extension DisasterTypeX on DisasterType {
  String get displayName {
    switch (this) {
      case DisasterType.cyclone:
        return 'Cyclone';
      case DisasterType.flood:
        return 'Flood';
      case DisasterType.heavyRain:
        return 'Heavy Rain';
      case DisasterType.heatwave:
        return 'Heatwave';
      case DisasterType.lightning:
        return 'Lightning Strike';
      case DisasterType.thunderstorm:
        return 'Severe Thunderstorm';
      case DisasterType.earthquake:
        return 'Earthquake';
      case DisasterType.fog:
        return 'Dense Fog';
      case DisasterType.coldWave:
        return 'Cold Wave';
      case DisasterType.landslide:
        return 'Landslide';
    }
  }

  IconData get icon {
    switch (this) {
      case DisasterType.cyclone:
        return Icons.cyclone;
      case DisasterType.flood:
        return Icons.water_rounded;
      case DisasterType.heavyRain:
        return Icons.grain_rounded;
      case DisasterType.heatwave:
        return Icons.wb_sunny_rounded;
      case DisasterType.lightning:
        return Icons.flash_on_rounded;
      case DisasterType.thunderstorm:
        return Icons.thunderstorm_rounded;
      case DisasterType.earthquake:
        return Icons.vibration_rounded;
      case DisasterType.fog:
        return Icons.blur_on_rounded;
      case DisasterType.coldWave:
        return Icons.ac_unit_rounded;
      case DisasterType.landslide:
        return Icons.landscape_rounded;
    }
  }
}

extension DisasterSeverityX on DisasterSeverity {
  String get label {
    switch (this) {
      case DisasterSeverity.info:
        return 'INFO';
      case DisasterSeverity.low:
        return 'LOW';
      case DisasterSeverity.moderate:
        return 'MODERATE';
      case DisasterSeverity.high:
        return 'HIGH';
      case DisasterSeverity.extreme:
        return 'EXTREME';
    }
  }

  Color get color {
    switch (this) {
      case DisasterSeverity.info:
        return const Color(0xFF3B82F6);
      case DisasterSeverity.low:
        return const Color(0xFF10B981);
      case DisasterSeverity.moderate:
        return const Color(0xFFF59E0B);
      case DisasterSeverity.high:
        return const Color(0xFFEF4444);
      case DisasterSeverity.extreme:
        return const Color(0xFFDC2626);
    }
  }
}

class DisasterAlert {
  final String id;
  final String title;
  final DisasterType type;
  final DisasterSeverity severity;
  final String affectedRegion;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> whatToDo;
  final List<String> whatToAvoid;
  final List<String> preparednessChecklist;
  final String source;
  final DateTime lastUpdated;

  const DisasterAlert({
    required this.id,
    required this.title,
    required this.type,
    required this.severity,
    required this.affectedRegion,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.whatToDo,
    required this.whatToAvoid,
    required this.preparednessChecklist,
    required this.source,
    required this.lastUpdated,
  });
}
