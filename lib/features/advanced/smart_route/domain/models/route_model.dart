
class RouteWaypoint {
  final String locationName;
  final double temperature;
  final String condition;
  final int rainProbability;
  final double visibilityKm;
  final double windSpeedKmh;
  final String hazardWarning;

  const RouteWaypoint({
    required this.locationName,
    required this.temperature,
    required this.condition,
    required this.rainProbability,
    required this.visibilityKm,
    required this.windSpeedKmh,
    this.hazardWarning = '',
  });
}

class RouteWeatherReport {
  final String origin;
  final String destination;
  final double totalDistanceKm;
  final String estimatedTravelTime;
  final List<RouteWaypoint> waypoints;
  final String overallHazardLevel; // Clear, Caution, High Hazard
  final String source;

  const RouteWeatherReport({
    required this.origin,
    required this.destination,
    required this.totalDistanceKm,
    required this.estimatedTravelTime,
    required this.waypoints,
    required this.overallHazardLevel,
    required this.source,
  });
}
