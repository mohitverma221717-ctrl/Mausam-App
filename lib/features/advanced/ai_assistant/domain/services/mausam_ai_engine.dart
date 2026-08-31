import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mausam_app/features/location/domain/models/location_model.dart';
import 'package:mausam_app/features/weather/domain/models/weather_data.dart';
import 'package:mausam_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:mausam_app/features/weather/presentation/providers/weather_provider.dart';
import '../models/ai_message_model.dart';

class MausamAiEngine {
  final WeatherRepository _weatherRepository;

  MausamAiEngine(this._weatherRepository);

  Future<MausamAiMessage> generateResponse(String userPrompt) async {
    final query = userPrompt.toLowerCase().trim();

    try {
      const defaultLoc = LocationModel(
        id: 'loc-default',
        name: 'New Delhi',
        state: 'Delhi',
        country: 'India',
        lat: 28.6139,
        lon: 77.2090,
        isCurrentLocation: true,
      );

      final weather = await _weatherRepository.getCurrentWeather(defaultLoc);

      String reply;
      if (query.contains('run') ||
          query.contains('jog') ||
          query.contains('fitness')) {
        reply = _evaluateRunningCondition(weather);
      } else if (query.contains('carry') ||
          query.contains('umbrella') ||
          query.contains('jacket') ||
          query.contains('pack')) {
        reply = _evaluateCarryItem(weather);
      } else if (query.contains('rain') || query.contains('shower')) {
        reply = _evaluateRainRisk(weather);
      } else if (query.contains('risk') ||
          query.contains('alert') ||
          query.contains('warning')) {
        reply = _evaluateWeatherRisks(weather);
      } else if (query.contains('destination') || query.contains('travel')) {
        reply =
            'Weather at your primary destination (${weather.cityName}) is currently ${weather.temperature.toInt()}°C with ${weather.condition}. UV index is ${weather.uvIndex} and AQI is ${weather.aqi} (${weather.aqiStatus}).';
      } else {
        reply =
            'Currently in ${weather.cityName}, it is ${weather.temperature.toInt()}°C with ${weather.condition}. Humidity is ${weather.humidity}%, wind is ${weather.windSpeed.toInt()} km/h (${weather.windDirection}), and rain probability is ${weather.rainProbability}%. Is there anything specific you would like to plan?';
      }

      return MausamAiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (_) {
      return MausamAiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text:
            "I don't have reliable weather data for that right now. Please try again when internet connectivity is restored.",
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  String _evaluateRunningCondition(WeatherData w) {
    if (w.aqi > 150) {
      return 'Outdoor running is NOT recommended today. The AQI in ${w.cityName} is currently ${w.aqi} (${w.aqiStatus}), which can cause respiratory strain. Consider indoor cardio instead.';
    }
    if (w.temperature > 38.0) {
      return 'Extreme heat alert: Temperature is ${w.temperature.toInt()}°C. Outdoor workouts carry a risk of heat exhaustion. If running, do so early before 7 AM and stay hydrated.';
    }
    if (w.rainProbability > 70) {
      return 'High chance of rain (${w.rainProbability}%). If running outdoors, wear water-resistant gear or run near shelter.';
    }
    return 'Conditions look great for running! Current temperature is ${w.temperature.toInt()}°C with ${w.condition} and moderate AQI (${w.aqi}). Enjoy your run!';
  }

  String _evaluateCarryItem(WeatherData w) {
    final List<String> items = [];
    if (w.rainProbability >= 40) {
      items.add('an umbrella or raincoat (Rain chance: ${w.rainProbability}%)');
    }
    if (w.uvIndex >= 6) {
      items.add('sunglasses and sunscreen (UV Index: ${w.uvIndex})');
    }
    if (w.aqi >= 120) {
      items.add('an N95 face mask (AQI: ${w.aqi})');
    }
    if (w.temperature < 15.0) {
      items.add('a warm jacket or sweater (${w.temperature.toInt()}°C)');
    }

    if (items.isEmpty) {
      return 'No special gear needed today! Temperature is pleasant at ${w.temperature.toInt()}°C with ${w.condition}.';
    }
    return 'For today in ${w.cityName}, it is recommended to carry: ${items.join(", ")}.';
  }

  String _evaluateRainRisk(WeatherData w) {
    if (w.rainProbability >= 60) {
      return 'Yes, there is a high probability of rain (${w.rainProbability}%) in ${w.cityName}. Current condition is ${w.condition}. Keep rain protection ready.';
    } else if (w.rainProbability >= 30) {
      return 'Scattered light showers are possible (${w.rainProbability}% probability) in ${w.cityName}. Cloud cover is around ${w.cloudCover}%.';
    } else {
      return 'Rain is unlikely today. Rain probability is only ${w.rainProbability}% with ${w.condition}.';
    }
  }

  String _evaluateWeatherRisks(WeatherData w) {
    final List<String> risks = [];
    if (w.aqi > 150) {
      risks.add('Unhealthy Air Quality (AQI: ${w.aqi})');
    }
    if (w.uvIndex >= 8) {
      risks.add('Very High UV Index (${w.uvIndex})');
    }
    if (w.temperature >= 40) {
      risks.add('Severe Heatwave (${w.temperature.toInt()}°C)');
    }
    if (w.windSpeed >= 40) {
      risks.add('High Wind Speeds (${w.windSpeed.toInt()} km/h)');
    }

    if (risks.isEmpty) {
      return 'No critical severe weather risks reported for ${w.cityName} right now. Conditions are stable.';
    }
    return 'Active weather advisories for ${w.cityName}: ${risks.join(", ")}. Stay safe and take precautions.';
  }
}

final mausamAiEngineProvider = Provider<MausamAiEngine>((ref) {
  final weatherRepo = ref.watch(weatherRepositoryProvider);
  return MausamAiEngine(weatherRepo);
});
