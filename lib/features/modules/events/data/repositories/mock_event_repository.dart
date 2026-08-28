import '../../domain/models/event_models.dart';

class MockEventRepository {
  Future<EventPlannerData> getEventPlannerData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return EventPlannerData(
      upcomingEvents: [
        PlannedEvent(
          id: 'evt-1',
          title: 'Wedding Event',
          eventDate: DateTime(2026, 8, 28, 19, 0),
          location: 'Janeshwar Mishra Park, Lucknow',
          isOutdoor: true,
          rainProbability: 20,
          comfortIndex: 'Good',
          expectedTemp: 29.0,
          expectedWind: 12.0,
          expectedHumidity: 58,
          suitabilityVerdict: 'Overall: Good for Outdoor Event',
          backupAdvice:
              'Low chance of rain. Canopies recommended for evening humidity control.',
        ),
        PlannedEvent(
          id: 'evt-2',
          title: 'Weekend Cricket Tournament',
          eventDate: DateTime(2026, 8, 30, 9, 0),
          location: 'KD Singh Babu Stadium',
          isOutdoor: true,
          rainProbability: 10,
          comfortIndex: 'Optimal',
          expectedTemp: 31.0,
          expectedWind: 14.0,
          expectedHumidity: 50,
          suitabilityVerdict: 'Ideal weather for outdoor sports match',
          backupAdvice: 'Keep hydration stands accessible during noon overs.',
        ),
      ],
      generalOutlook:
          'Stable weather conditions projected for all upcoming outdoor events this week.',
    );
  }
}
