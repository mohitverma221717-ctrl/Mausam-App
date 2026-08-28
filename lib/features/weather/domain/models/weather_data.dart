import 'package:flutter/material.dart';

enum WeatherConditionType {
  sunny,
  clearNight,
  partlyCloudy,
  partlyCloudyNight,
  cloudy,
  rainy,
  heavyRain,
  thunderstorm,
  foggy,
  snowy,
  windy,
}

class WeatherData {
  final String cityName;
  final String stateName;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String condition;
  final WeatherConditionType conditionType;
  final int humidity; // %
  final double windSpeed; // km/h
  final String windDirection;
  final int pressure; // hPa
  final double visibility; // km
  final int uvIndex;
  final int aqi;
  final String aqiStatus; // Good, Moderate, Unhealthy, etc.
  final int cloudCover; // %
  final int rainProbability; // %
  final String sunrise;
  final String sunset;
  final DateTime lastUpdated;
  final double lat;
  final double lon;

  const WeatherData({
    required this.cityName,
    required this.stateName,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.conditionType,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.aqi,
    required this.aqiStatus,
    required this.cloudCover,
    required this.rainProbability,
    required this.sunrise,
    required this.sunset,
    required this.lastUpdated,
    required this.lat,
    required this.lon,
  });

  IconData get iconData {
    switch (conditionType) {
      case WeatherConditionType.sunny:
        return Icons.wb_sunny_rounded;
      case WeatherConditionType.clearNight:
        return Icons.nightlight_round;
      case WeatherConditionType.partlyCloudy:
        return Icons.cloud_queue_rounded;
      case WeatherConditionType.partlyCloudyNight:
        return Icons.nights_stay_rounded;
      case WeatherConditionType.cloudy:
        return Icons.cloud_rounded;
      case WeatherConditionType.rainy:
        return Icons.grain_rounded;
      case WeatherConditionType.heavyRain:
        return Icons.thunderstorm_rounded;
      case WeatherConditionType.thunderstorm:
        return Icons.flash_on_rounded;
      case WeatherConditionType.foggy:
        return Icons.blur_on_rounded;
      case WeatherConditionType.snowy:
        return Icons.ac_unit_rounded;
      case WeatherConditionType.windy:
        return Icons.air_rounded;
    }
  }
}

class HourlyForecast {
  final String time; // e.g. "12 PM"
  final double temperature;
  final String condition;
  final WeatherConditionType conditionType;
  final int rainProbability;
  final double windSpeed;
  final int humidity;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.conditionType,
    required this.rainProbability,
    required this.windSpeed,
    required this.humidity,
  });
}

class DailyForecast {
  final DateTime date;
  final String dayName; // e.g. "Today", "Tue", "Wed"
  final double tempMax;
  final double tempMin;
  final String condition;
  final WeatherConditionType conditionType;
  final int rainProbability;
  final double windSpeed;
  final int humidity;
  final int uvIndex;
  final String summary;

  const DailyForecast({
    required this.date,
    required this.dayName,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.conditionType,
    required this.rainProbability,
    required this.windSpeed,
    required this.humidity,
    required this.uvIndex,
    required this.summary,
  });
}
