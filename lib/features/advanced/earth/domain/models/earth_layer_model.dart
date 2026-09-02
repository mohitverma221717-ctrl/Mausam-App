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
        return 'm swell';
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
        return const Color(0xFFEF4444);
      case EarthLayerType.precipitation:
        return const Color(0xFF0284C7);
      case EarthLayerType.clouds:
        return const Color(0xFF94A3B8);
      case EarthLayerType.wind:
        return const Color(0xFF06B6D4);
      case EarthLayerType.humidity:
        return const Color(0xFF3B82F6);
      case EarthLayerType.pressure:
        return const Color(0xFFF59E0B);
      case EarthLayerType.airQuality:
        return const Color(0xFF10B981);
      case EarthLayerType.uv:
        return const Color(0xFFEC4899);
      case EarthLayerType.alerts:
        return const Color(0xFFDC2626);
      case EarthLayerType.cyclones:
        return const Color(0xFFE11D48);
      case EarthLayerType.lightning:
        return const Color(0xFFA855F7);
      case EarthLayerType.visibility:
        return const Color(0xFF64748B);
      case EarthLayerType.marine:
        return const Color(0xFF0D9488);
      case EarthLayerType.soil:
        return const Color(0xFF84CC16);
    }
  }

  List<Color> get legendColors {
    switch (this) {
      case EarthLayerType.temperature:
        return const [Color(0xFF3B82F6), Color(0xFF06B6D4), Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFEF4444)];
      case EarthLayerType.precipitation:
        return const [Color(0xFFE0F2FE), Color(0xFF38BDF8), Color(0xFF0284C7), Color(0xFF1E40AF)];
      case EarthLayerType.clouds:
        return const [Color(0x33FFFFFF), Color(0x88FFFFFF), Color(0xDDFFFFFF)];
      case EarthLayerType.wind:
        return const [Color(0xFF06B6D4), Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFEF4444)];
      case EarthLayerType.humidity:
        return const [Color(0xFFFEF3C7), Color(0xFF60A5FA), Color(0xFF1D4ED8)];
      case EarthLayerType.pressure:
        return const [Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFF59E0B)];
      case EarthLayerType.airQuality:
        return const [Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF8B5CF6)];
      case EarthLayerType.uv:
        return const [Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF8B5CF6)];
      case EarthLayerType.alerts:
        return const [Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF991B1B)];
      case EarthLayerType.cyclones:
        return const [Color(0xFF38BDF8), Color(0xFFF59E0B), Color(0xFFEF4444)];
      case EarthLayerType.lightning:
        return const [Color(0xFFFDE047), Color(0xFFA855F7), Color(0xFFDC2626)];
      case EarthLayerType.visibility:
        return const [Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFF10B981)];
      case EarthLayerType.marine:
        return const [Color(0xFF0D9488), Color(0xFF0284C7), Color(0xFF1E3A8A)];
      case EarthLayerType.soil:
        return const [Color(0xFF78350F), Color(0xFF84CC16), Color(0xFF10B981)];
    }
  }

  String get minScaleLabel {
    switch (this) {
      case EarthLayerType.temperature:
        return '-10°C';
      case EarthLayerType.precipitation:
        return '0';
      case EarthLayerType.clouds:
        return '0%';
      case EarthLayerType.wind:
        return '0';
      case EarthLayerType.humidity:
        return '0%';
      case EarthLayerType.pressure:
        return '980';
      case EarthLayerType.airQuality:
        return '0 (Good)';
      case EarthLayerType.uv:
        return '0 (Low)';
      case EarthLayerType.alerts:
        return 'Watch';
      case EarthLayerType.cyclones:
        return 'Depression';
      case EarthLayerType.lightning:
        return 'Low';
      case EarthLayerType.visibility:
        return '0 km';
      case EarthLayerType.marine:
        return '0 m';
      case EarthLayerType.soil:
        return '0%';
    }
  }

  String get maxScaleLabel {
    switch (this) {
      case EarthLayerType.temperature:
        return '45°C';
      case EarthLayerType.precipitation:
        return '50+';
      case EarthLayerType.clouds:
        return '100%';
      case EarthLayerType.wind:
        return '120+';
      case EarthLayerType.humidity:
        return '100%';
      case EarthLayerType.pressure:
        return '1040';
      case EarthLayerType.airQuality:
        return '300+ (Hazardous)';
      case EarthLayerType.uv:
        return '11+ (Extreme)';
      case EarthLayerType.alerts:
        return 'Emergency';
      case EarthLayerType.cyclones:
        return 'Cat 5 Severe';
      case EarthLayerType.lightning:
        return 'Extreme';
      case EarthLayerType.visibility:
        return '20+ km';
      case EarthLayerType.marine:
        return '8+ m';
      case EarthLayerType.soil:
        return '100%';
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
