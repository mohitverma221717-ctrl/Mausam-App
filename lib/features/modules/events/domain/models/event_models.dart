class PlannedEvent {
  final String id;
  final String title; // "Wedding Event"
  final DateTime eventDate; // "28 Aug 2026"
  final String location; // "Lucknow"
  final bool isOutdoor;
  final int rainProbability; // 20%
  final String comfortIndex; // "Good"
  final double expectedTemp; // 29°C
  final double expectedWind; // 12 km/h
  final int expectedHumidity; // 55%
  final String suitabilityVerdict; // "Overall: Good for Outdoor Event"
  final String backupAdvice;

  const PlannedEvent({
    required this.id,
    required this.title,
    required this.eventDate,
    required this.location,
    required this.isOutdoor,
    required this.rainProbability,
    required this.comfortIndex,
    required this.expectedTemp,
    required this.expectedWind,
    required this.expectedHumidity,
    required this.suitabilityVerdict,
    required this.backupAdvice,
  });
}

class EventPlannerData {
  final List<PlannedEvent> upcomingEvents;
  final String generalOutlook;

  const EventPlannerData({
    required this.upcomingEvents,
    required this.generalOutlook,
  });
}
