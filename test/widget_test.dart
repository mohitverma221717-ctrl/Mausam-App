import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mausam_app/core/theme/app_theme.dart';
import 'package:mausam_app/core/widgets/weather_hero_card.dart';
import 'package:mausam_app/core/widgets/weather_metric_tile.dart';
import 'package:mausam_app/core/widgets/personalized_recommendation_card.dart';
import 'package:mausam_app/features/weather/domain/models/weather_data.dart';
import 'package:mausam_app/features/personalization/domain/models/personalization_models.dart';

void main() {
  testWidgets('WeatherHeroCard renders temperature and condition',
      (WidgetTester tester) async {
    final weather = WeatherData(
      cityName: 'Lucknow',
      stateName: 'Uttar Pradesh',
      temperature: 29.0,
      feelsLike: 31.0,
      tempMin: 24.0,
      tempMax: 34.0,
      condition: 'Partly Cloudy',
      conditionType: WeatherConditionType.partlyCloudy,
      humidity: 68,
      windSpeed: 12.0,
      windDirection: 'ENE',
      pressure: 1012,
      visibility: 6.0,
      uvIndex: 5,
      aqi: 82,
      aqiStatus: 'Good',
      cloudCover: 40,
      rainProbability: 20,
      sunrise: '05:46 AM',
      sunset: '06:28 PM',
      lastUpdated: DateTime.now(),
      lat: 26.8467,
      lon: 80.9462,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: WeatherHeroCard(weather: weather),
          ),
        ),
      ),
    );

    expect(find.text('29'), findsOneWidget);
    expect(find.text('Partly Cloudy'), findsOneWidget);
    expect(find.text('Feels like 31°'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'WeatherMetricTile does not overflow in 2-column grid at 360px screen width',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.36,
              children: const [
                WeatherMetricTile(
                  title: 'Air Quality (AQI)',
                  value: '82 • Good',
                  subtitle: 'PM2.5: 25 µg/m³',
                  icon: Icons.air_rounded,
                  progress: 0.25,
                ),
                WeatherMetricTile(
                  title: 'UV Index',
                  value: '5 Moderate',
                  subtitle: 'SPF 30+ recommended',
                  icon: Icons.wb_sunny_outlined,
                  progress: 0.5,
                ),
                WeatherMetricTile(
                  title: 'Humidity',
                  value: '68%',
                  subtitle: 'Dew point 21°C',
                  icon: Icons.water_drop_outlined,
                  progress: 0.68,
                ),
                WeatherMetricTile(
                  title: 'Wind Speed',
                  value: '12 km/h',
                  subtitle: 'Direction: ENE',
                  icon: Icons.navigation_rounded,
                  progress: 0.35,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Air Quality (AQI)'), findsOneWidget);
    expect(find.text('82 • Good'), findsOneWidget);
    expect(find.text('SPF 30+ recommended'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'PersonalizedRecommendationCard renders long title and badge without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    const sampleCard = PersonalizedCardData(
      id: 'agri_1',
      interest: UserInterest.agriculture,
      title: 'Agriculture & Farm Weather',
      subtitle: 'Optimal soil moisture for wheat sowing and soil prep.',
      badgeText: 'Sensor Connected',
      priorityScore: 92.0,
      icon: Icons.agriculture_rounded,
      metrics: {
        'Rain Forecast': '72%',
        'Soil Moisture': '42%',
        'Frost Risk': 'Low',
        'Farm Temp': '28°C',
      },
      primaryActionRoute: '/explore/agriculture',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: PersonalizedRecommendationCard(data: sampleCard),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Agriculture & Farm Weather'), findsOneWidget);
    expect(find.text('Sensor Connected'), findsOneWidget);
    expect(find.text('Open Agriculture & Farm Weather'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
