import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route_model.dart';

abstract class RouteRepository {
  Future<RouteWeatherReport> getRouteWeather(String origin, String destination);
}

class MockRouteRepository implements RouteRepository {
  @override
  Future<RouteWeatherReport> getRouteWeather(
      String origin, String destination) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return RouteWeatherReport(
      origin: origin.isEmpty ? 'Home (Connaught Place, Delhi)' : origin,
      destination:
          destination.isEmpty ? 'Work (Cyber City, Gurugram)' : destination,
      totalDistanceKm: 28.5,
      estimatedTravelTime: '45 mins',
      overallHazardLevel: 'Caution',
      waypoints: const [
        RouteWaypoint(
          locationName: 'Start: Connaught Place',
          temperature: 32.0,
          condition: 'Partly Cloudy',
          rainProbability: 20,
          visibilityKm: 6.0,
          windSpeedKmh: 12.0,
        ),
        RouteWaypoint(
          locationName: 'Midpoint: Dhaula Kuan Flyover',
          temperature: 31.5,
          condition: 'Light Rain',
          rainProbability: 65,
          visibilityKm: 4.2,
          windSpeedKmh: 18.0,
          hazardWarning: 'Slippery roads & reduced visibility',
        ),
        RouteWaypoint(
          locationName: 'Destination: Cyber City Gurugram',
          temperature: 31.0,
          condition: 'Moderate Rain',
          rainProbability: 80,
          visibilityKm: 3.5,
          windSpeedKmh: 22.0,
          hazardWarning: 'Waterlogging reported near IFFCO Chowk',
        ),
      ],
      source: 'Mausam Route Intelligence Engine & Open-Meteo',
    );
  }
}

final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  return MockRouteRepository();
});
