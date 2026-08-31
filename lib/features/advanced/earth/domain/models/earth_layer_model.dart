import 'package:flutter/material.dart';

enum EarthLayerType {
  clouds,
  precipitation,
  temperature,
  wind,
  airQuality,
}

extension EarthLayerTypeX on EarthLayerType {
  String get title {
    switch (this) {
      case EarthLayerType.clouds:
        return 'Cloud Cover';
      case EarthLayerType.precipitation:
        return 'Precipitation';
      case EarthLayerType.temperature:
        return 'Temperature';
      case EarthLayerType.wind:
        return 'Wind Streams';
      case EarthLayerType.airQuality:
        return 'AQI Layer';
    }
  }

  IconData get icon {
    switch (this) {
      case EarthLayerType.clouds:
        return Icons.cloud_rounded;
      case EarthLayerType.precipitation:
        return Icons.grain_rounded;
      case EarthLayerType.temperature:
        return Icons.thermostat_rounded;
      case EarthLayerType.wind:
        return Icons.air_rounded;
      case EarthLayerType.airQuality:
        return Icons.blur_on_rounded;
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
