import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mausam_app/core/theme/app_theme.dart';
import 'package:mausam_app/core/widgets/weather_3d_background_layer.dart';
import 'package:mausam_app/core/widgets/weather_3d_showcase_card.dart';
import 'package:mausam_app/core/widgets/weather_3d_visual_canvas.dart';
import 'package:mausam_app/features/weather/domain/models/weather_data.dart';
import 'package:mausam_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:mausam_app/features/location/domain/models/location_model.dart';
import 'package:mausam_app/features/location/presentation/providers/location_provider.dart';

void main() {
  group('Automatic 3D Weather System Integration Tests', () {
    test('resolveEffectiveCondition maps weather conditions and day/night accurately', () {
      final sunnyDayWeather = WeatherData(
        cityName: 'Lucknow',
        stateName: 'Uttar Pradesh',
        temperature: 30.0,
        feelsLike: 32.0,
        tempMin: 25.0,
        tempMax: 35.0,
        condition: 'Sunny',
        conditionType: WeatherConditionType.sunny,
        humidity: 50,
        windSpeed: 10.0,
        windDirection: 'N',
        pressure: 1012,
        visibility: 10.0,
        uvIndex: 8,
        aqi: 70,
        aqiStatus: 'Good',
        cloudCover: 10,
        rainProbability: 5,
        sunrise: '05:00 AM',
        sunset: '11:00 PM', // daytime for test
        lastUpdated: DateTime.now(),
        lat: 26.8467,
        lon: 80.9462,
      );

      final cond = Weather3dBackgroundLayer.resolveEffectiveCondition(
        sunnyDayWeather,
        null,
      );
      expect(cond, WeatherConditionType.sunny);

      final rainWeather = WeatherData(
        cityName: 'London',
        stateName: 'UK',
        temperature: 15.0,
        feelsLike: 14.0,
        tempMin: 12.0,
        tempMax: 18.0,
        condition: 'Heavy Rain',
        conditionType: WeatherConditionType.heavyRain,
        humidity: 85,
        windSpeed: 20.0,
        windDirection: 'SW',
        pressure: 1005,
        visibility: 5.0,
        uvIndex: 2,
        aqi: 30,
        aqiStatus: 'Good',
        cloudCover: 90,
        rainProbability: 80,
        sunrise: '06:00 AM',
        sunset: '08:00 PM',
        lastUpdated: DateTime.now(),
        lat: 51.5074,
        lon: -0.1278,
      );

      final rainCond = Weather3dBackgroundLayer.resolveEffectiveCondition(
        rainWeather,
        null,
      );
      expect(rainCond, WeatherConditionType.heavyRain);
    });

    testWidgets('Weather3dBackgroundLayer builds and mounts 3D visual canvas automatically',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Weather3dBackgroundLayer(
                child: Text('Main Weather Screen'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Main Weather Screen'), findsOneWidget);
      expect(find.byType(Weather3dVisualCanvas), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Weather3dShowcaseCard renders live 3D visual without manual choice chips',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Weather3dShowcaseCard(),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('3D Dynamic Weather Engine'), findsOneWidget);
      expect(find.text('LIVE 3D'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Location change automatically updates 3D weather visual state',
        (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Weather3dBackgroundLayer(
                child: Text('Location Weather View'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Location Weather View'), findsOneWidget);

      // Select London (Rainy weather)
      container.read(locationProvider.notifier).selectLocation(
            const LocationModel(
              id: 'loc_london',
              name: 'London',
              state: 'United Kingdom',
              country: 'UK',
              lat: 51.5074,
              lon: -0.1278,
            ),
          );
      await container.read(weatherProvider.notifier).fetchWeather();
      await tester.pump(const Duration(seconds: 2));

      final weatherState = container.read(weatherProvider);
      expect(weatherState.currentWeather?.cityName, 'London');
      expect(weatherState.currentWeather?.conditionType, WeatherConditionType.rainy);
      expect(find.byType(Weather3dVisualCanvas), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
