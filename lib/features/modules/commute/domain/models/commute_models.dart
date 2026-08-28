class CommuteSegment {
  final String title; // "Home → Office"
  final String origin;
  final String destination;
  final String trafficStatus; // "Moderate", "Heavy", "Smooth"
  final int rainChance; // 40%
  final double visibilityKm; // 6 km
  final double windSpeed; // 10 km/h
  final String conditionSummary; // "Moderate Conditions"
  final String? fogWarning;

  const CommuteSegment({
    required this.title,
    required this.origin,
    required this.destination,
    required this.trafficStatus,
    required this.rainChance,
    required this.visibilityKm,
    required this.windSpeed,
    required this.conditionSummary,
    this.fogWarning,
  });
}

class CommuteData {
  final CommuteSegment activeRoute;
  final List<CommuteSegment> savedRoutes;
  final String overallAdvice;

  const CommuteData({
    required this.activeRoute,
    required this.savedRoutes,
    required this.overallAdvice,
  });
}
