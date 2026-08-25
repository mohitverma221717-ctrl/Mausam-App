import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mausam_app/core/localization/app_localizations.dart';
import 'package:mausam_app/features/location/domain/models/location_model.dart';
import 'package:mausam_app/features/personalization/domain/models/personalization_models.dart';
import 'package:mausam_app/features/personalization/domain/services/personalization_engine.dart';
import 'package:mausam_app/features/weather/data/repositories/mock_weather_repository.dart';
import 'package:mausam_app/features/alerts/data/repositories/mock_alert_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersonalizationEngine Tests', () {
    test('Calculates and scores prioritized cards for Health & Fitness',
        () async {
      final weatherRepo = MockWeatherRepository();
      final alertRepo = MockAlertRepository();
      const testLocation = LocationModel(
        id: 'test-loc',
        name: 'Lucknow',
        state: 'Uttar Pradesh',
        country: 'India',
        lat: 26.8467,
        lon: 80.9462,
      );

      final weather = await weatherRepo.getCurrentWeather(testLocation);
      final alerts = await alertRepo.getActiveAlerts(testLocation);

      final cards = PersonalizationEngine.computePersonalizedCards(
        selectedInterests: [UserInterest.health, UserInterest.fitness],
        priorityRules: [
          const PriorityRule(interest: UserInterest.health, rank: 1),
          const PriorityRule(interest: UserInterest.fitness, rank: 2),
        ],
        weather: weather,
        activeAlerts: alerts,
      );

      expect(cards.isNotEmpty, true);
      expect(cards.first.interest, UserInterest.health);
      expect(cards.any((c) => c.interest == UserInterest.fitness), true);
    });

    test('All 8 Specialized Domain modules produce valid cards', () async {
      final weatherRepo = MockWeatherRepository();
      const testLocation = LocationModel(
        id: 'test-loc',
        name: 'Lucknow',
        state: 'Uttar Pradesh',
        country: 'India',
        lat: 26.8467,
        lon: 80.9462,
      );

      final weather = await weatherRepo.getCurrentWeather(testLocation);

      final cards = PersonalizationEngine.computePersonalizedCards(
        selectedInterests: UserInterest.values,
        priorityRules: UserInterest.values.asMap().entries.map((e) {
          return PriorityRule(interest: e.value, rank: e.key + 1);
        }).toList(),
        weather: weather,
        activeAlerts: [],
      );

      expect(cards.length, 8);
    });
  });

  group('WeatherRepository Tests', () {
    test('MockWeatherRepository returns valid weather and forecasts', () async {
      final repo = MockWeatherRepository();
      const testLoc = LocationModel(
        id: 'test-lucknow',
        name: 'Lucknow',
        state: 'Uttar Pradesh',
        country: 'India',
        lat: 26.8467,
        lon: 80.9462,
      );

      final current = await repo.getCurrentWeather(testLoc);
      final hourly = await repo.getHourlyForecast(testLoc);
      final daily = await repo.getDailyForecast(testLoc);

      expect(current.cityName, 'Lucknow');
      expect(current.temperature, 29.0);
      expect(hourly.length, greaterThanOrEqualTo(5));
      expect(daily.length, 7);
    });
  });

  group('Localization Engine Tests', () {
    test('Translates keys correctly in English and Hindi', () {
      final l10nEn = AppLocalizations(const Locale('en'));
      final l10nHi = AppLocalizations(const Locale('hi'));

      expect(l10nEn.translate('appName'), 'MAUSAM');
      expect(l10nHi.translate('appName'), 'मौसम');

      expect(l10nEn.translate('hourlyForecast'), 'Hourly Forecast');
      expect(l10nHi.translate('hourlyForecast'), 'प्रति घंटे का पूर्वानुमान');
    });
  });
}
