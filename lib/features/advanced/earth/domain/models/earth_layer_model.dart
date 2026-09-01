import 'package:flutter/material.dart';

enum EarthLayerType {
  temperature,
  precipitation,
  clouds,
  wind,
  humidity,
  pressure,
  airQuality,
  uv,
  alerts,
  cyclones,
  lightning,
  visibility,
  marine,
  soil,
}

extension EarthLayerTypeX on EarthLayerType {
  String get title {
    switch (this) {
      case EarthLayerType.temperature:
        return 'Temperature';
      case EarthLayerType.precipitation:
        return 'Precipitation';
      case EarthLayerType.clouds:
        return 'Cloud Cover';
      case EarthLayerType.wind:
        return 'Wind Vectors';
      case EarthLayerType.humidity:
        return 'Humidity';
      case EarthLayerType.pressure:
        return 'Pressure Isobars';
      case EarthLayerType.airQuality:
        return 'AQI Index';
      case EarthLayerType.uv:
        return 'UV Radiation';
      case EarthLayerType.alerts:
        return 'Severe Alerts';
      case EarthLayerType.cyclones:
        return 'Cyclone Tracking';
      case EarthLayerType.lightning:
        return 'Lightning Strikes';
      case EarthLayerType.visibility:
        return 'Visibility Range';
      case EarthLayerType.marine:
        return 'Marine Waves';
      case EarthLayerType.soil:
        return 'Soil Moisture';
    }
  }

  String get unitLabel {
    switch (this) {
      case EarthLayerType.temperature:
        return '°C';
      case EarthLayerType.precipitation:
        return 'mm/h';
      case EarthLayerType.clouds:
        return '%';
      case EarthLayerType.wind:
        return 'km/h';
      case EarthLayerType.humidity:
        return '%';
      case EarthLayerType.pressure:
        return 'hPa';
      case EarthLayerType.airQuality:
        return 'AQI';
      case EarthLayerType.uv:
        return 'Index';
      case EarthLayerType.alerts:
        return 'Active';
      case EarthLayerType.cyclones:
        return 'Category';
      case EarthLayerType.lightning:
        return 'Strikes/m²';
      case EarthLayerType.visibility:
        return 'km';
      case EarthLayerType.marine:
        return 'meters';
      case EarthLayerType.soil:
        return '% moisture';
    }
  }

  IconData get icon {
    switch (this) {
      case EarthLayerType.temperature:
        return Icons.thermostat_rounded;
      case EarthLayerType.precipitation:
        return Icons.grain_rounded;
      case EarthLayerType.clouds:
        return Icons.cloud_rounded;
      case EarthLayerType.wind:
        return Icons.air_rounded;
      case EarthLayerType.humidity:
        return Icons.water_drop_rounded;
      case EarthLayerType.pressure:
        return Icons.compress_rounded;
      case EarthLayerType.airQuality:
        return Icons.blur_on_rounded;
      case EarthLayerType.uv:
        return Icons.wb_sunny_rounded;
      case EarthLayerType.alerts:
        return Icons.warning_amber_rounded;
      case EarthLayerType.cyclones:
        return Icons.cyclone_rounded;
      case EarthLayerType.lightning:
        return Icons.flash_on_rounded;
      case EarthLayerType.visibility:
        return Icons.visibility_rounded;
      case EarthLayerType.marine:
        return Icons.sailing_rounded;
      case EarthLayerType.soil:
        return Icons.grass_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case EarthLayerType.temperature:
        return const Color(0xFFEF4444); // Red
      case EarthLayerType.precipitation:
        return const Color(0xFF0284C7); // Blue
      case EarthLayerType.clouds:
        return const Color(0xFF94A3B8); // Slate
      case EarthLayerType.wind:
        return const Color(0xFF06B6D4); // Cyan
      case EarthLayerType.humidity:
        return const Color(0xFF3B82F6); // Blue
      case EarthLayerType.pressure:
        return const Color(0xFFF59E0B); // Amber
      case EarthLayerType.airQuality:
        return const Color(0xFF10B981); // Emerald Green
      case EarthLayerType.uv:
        return const Color(0xFFEC4899); // Pink
      case EarthLayerType.alerts:
        return const Color(0xFFDC2626); // Crimson
      case EarthLayerType.cyclones:
        return const Color(0xFFE11D48); // Rose
      case EarthLayerType.lightning:
        return const Color(0xFFA855F7); // Purple
      case EarthLayerType.visibility:
        return const Color(0xFF64748B); // Cool Grey
      case EarthLayerType.marine:
        return const Color(0xFF0D9488); // Teal
      case EarthLayerType.soil:
        return const Color(0xFF84CC16); // Lime
    }
  }
}

class EarthLayer {
  final EarthLayerType type;
  final String title;
  final String description;
  final String tileUrlTemplate;

  const EarthLayer({
    required this.type,
    required this.title,
    required this.description,
    required this.tileUrlTemplate,
  });
}

