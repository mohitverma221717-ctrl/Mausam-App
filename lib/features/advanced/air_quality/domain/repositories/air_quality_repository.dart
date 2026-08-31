import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/air_quality_model.dart';

abstract class AirQualityRepository {
  Future<AirQualityData> getAirQuality(double lat, double lon);
}

class MockAirQualityRepository implements AirQualityRepository {
  @override
  Future<AirQualityData> getAirQuality(double lat, double lon) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AirQualityData(
      aqi: 138,
      pm25: 54.2,
      pm10: 112.5,
      no2: 24.8,
      o3: 42.1,
      category: 'Unhealthy for Sensitive Groups',
      healthAdvice:
          'Members of sensitive groups (asthma, elderly, children) should reduce outdoor exertion and wear N95 masks.',
      source: 'Central Pollution Control Board & Open-Meteo Air Quality API',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
    );
  }
}

final airQualityRepositoryProvider = Provider<AirQualityRepository>((ref) {
  return MockAirQualityRepository();
});

final airQualityDataProvider = FutureProvider<AirQualityData>((ref) async {
  final repo = ref.watch(airQualityRepositoryProvider);
  return repo.getAirQuality(28.6139, 77.2090);
});
