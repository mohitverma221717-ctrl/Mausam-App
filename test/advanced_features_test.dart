import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/features/advanced/personalization/domain/personalization_engine.dart';
import 'package:mausam_app/features/advanced/smart_notifications/domain/smart_notification_engine.dart';
import 'package:mausam_app/features/advanced/disaster/domain/models/disaster_model.dart';
import 'package:mausam_app/features/advanced/disaster/domain/repositories/disaster_repository.dart';
import 'package:mausam_app/features/advanced/cyclone/domain/repositories/cyclone_repository.dart';
import 'package:mausam_app/features/advanced/earthquake/domain/repositories/earthquake_repository.dart';
import 'package:mausam_app/features/weather/domain/models/weather_data.dart';

void main() {
  group('MAUSAM 2.0 Advanced Feature Unit Tests', () {
    test('PersonalizationEngine prioritizes high rain probability', () {
      final sampleWeather = WeatherData(
        cityName: 'Delhi',
        stateName: 'Delhi',
        temperature: 30.0,
        feelsLike: 32.0,
        tempMin: 25.0,
        tempMax: 35.0,
        condition: 'Rainy',
        conditionType: WeatherConditionType.rainy,
        humidity: 80,
        windSpeed: 15.0,
        windDirection: 'NE',
        pressure: 1010,
        visibility: 5.0,
        uvIndex: 4,
        aqi: 90,
        aqiStatus: 'Good',
        cloudCover: 75,
        rainProbability: 85,
        sunrise: '6:00 AM',
        sunset: '7:00 PM',
        lastUpdated: DateTime.now(),
        lat: 28.61,
        lon: 77.20,
      );

      final cards = PersonalizationEngine.generateCards(
        weather: sampleWeather,
        activeDisasters: [],
      );

      expect(cards.isNotEmpty, true);
      expect(cards.first.id, 'card-rain-nowcast');
    });

    test('SmartNotificationEngine handles duplicate suppression', () {
      final engine = SmartNotificationEngine();
      final notification = MausamNotification(
        id: 'notif-1',
        category: NotificationCategory.cyclone,
        title: 'Cyclone Warning',
        body: 'Category 3 cyclone approaching coast',
        priority: NotificationPriority.critical,
        timestamp: DateTime.now(),
        location: 'Odisha Coast',
        source: 'IMD',
      );

      final firstDeliver = engine.shouldDeliverNotification(notification);
      final secondDeliver = engine.shouldDeliverNotification(notification);

      expect(firstDeliver, true);
      expect(secondDeliver, false); // Duplicate suppressed
    });

    test('MockDisasterRepository fetches active advisories', () async {
      final repo = MockDisasterRepository();
      final disasters = await repo.getActiveDisasters();

      expect(disasters.isNotEmpty, true);
      expect(disasters.first.type, DisasterType.cyclone);
    });

    test('MockCycloneRepository returns valid cyclone track data', () async {
      final repo = MockCycloneRepository();
      final cyclones = await repo.getActiveCyclones();

      expect(cyclones.isNotEmpty, true);
      expect(cyclones.first.name, 'Cyclone REMAL');
      expect(cyclones.first.forecastPath.isNotEmpty, true);
    });

    test('MockEarthquakeRepository returns recent seismic events', () async {
      final repo = MockEarthquakeRepository();
      final events = await repo.getRecentEarthquakes();

      expect(events.isNotEmpty, true);
      expect(events.first.magnitude, greaterThan(0.0));
    });
  });
}
