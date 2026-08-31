import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';

abstract class EventIntelligenceRepository {
  Future<EventPlanReport> evaluateEvent({
    required String name,
    required String location,
    required DateTime date,
    required bool isOutdoor,
  });
}

class MockEventIntelligenceRepository implements EventIntelligenceRepository {
  @override
  Future<EventPlanReport> evaluateEvent({
    required String name,
    required String location,
    required DateTime date,
    required bool isOutdoor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return EventPlanReport(
      eventName: name.isEmpty ? 'Outdoor Wedding Reception' : name,
      location: location.isEmpty ? 'Nehru Park, Chanakyapuri' : location,
      eventDate: date,
      timeRange: '4:00 PM – 10:00 PM',
      isOutdoor: isOutdoor,
      tempMin: 22.0,
      tempMax: 29.5,
      rainProbability: 25,
      windSpeedKmh: 14.0,
      humidity: 55,
      suitabilityRating: 'Highly Favorable',
      summaryExplanation:
          'Outdoor conditions currently look favorable with mild evening temperatures (24°C) and low precipitation probability (25%).',
      disclaimer:
          'Note: Weather forecasts can change. Re-check 24 hours prior to the event.',
    );
  }
}

final eventIntelligenceRepositoryProvider =
    Provider<EventIntelligenceRepository>((ref) {
  return MockEventIntelligenceRepository();
});
