import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mausam_app/core/theme/app_theme.dart';
import 'package:mausam_app/core/widgets/weather_hero_card.dart';
import 'package:mausam_app/core/widgets/weather_metric_tile.dart';
import 'package:mausam_app/core/widgets/personalized_recommendation_card.dart';
import 'package:mausam_app/features/weather/domain/models/weather_data.dart';
import 'package:mausam_app/features/personalization/domain/models/personalization_models.dart';
import 'package:mausam_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:mausam_app/features/explore/presentation/screens/explore_screen.dart';
import 'package:mausam_app/features/alerts/presentation/screens/alerts_screen.dart';
import 'package:mausam_app/features/modules/agriculture/presentation/screens/agriculture_screen.dart';
import 'package:mausam_app/features/modules/commute/presentation/screens/commute_screen.dart';
import 'package:mausam_app/features/modules/events/presentation/screens/event_screen.dart';
import 'package:mausam_app/features/modules/family/presentation/screens/family_screen.dart';
import 'package:mausam_app/features/modules/fitness/presentation/screens/fitness_screen.dart';
import 'package:mausam_app/features/modules/health/presentation/screens/health_screen.dart';
import 'package:mausam_app/features/modules/marine/presentation/screens/marine_screen.dart';
import 'package:mausam_app/features/modules/travel/presentation/screens/travel_screen.dart';
import 'package:mausam_app/features/radar/presentation/screens/radar_screen.dart';
import 'package:mausam_app/core/widgets/mausam_module_drawer.dart';
import 'package:mausam_app/features/alerts/presentation/screens/notification_center_screen.dart';
import 'package:mausam_app/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:mausam_app/features/settings/presentation/screens/units_screen.dart';
import 'package:mausam_app/features/settings/presentation/screens/language_screen.dart';
import 'package:mausam_app/features/settings/presentation/screens/help_feedback_screen.dart';
import 'package:mausam_app/features/settings/presentation/screens/about_screen.dart';
import 'package:mausam_app/features/settings/presentation/screens/aod_screen.dart';
import 'package:mausam_app/features/settings/presentation/screens/appearance_screen.dart';

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

  testWidgets(
      'SplashScreen renders branding, subtitle, and loader without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SplashScreen(),
          ),
        ),
      ),
    );

    expect(find.text('Mausam'), findsOneWidget);
    expect(find.text('Personalized Weather for You'), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'ExploreScreen renders 8 specialized dashboard modules with zero overflow across 320px and 360px devices',
      (WidgetTester tester) async {
    for (final width in [320.0, 360.0, 412.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExploreScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('8 Specialized Weather Dashboards'), findsOneWidget);
      expect(find.text('Health & AQI'), findsOneWidget);
      expect(find.text('Fitness & Running'), findsOneWidget);
      expect(find.text('Marine & Surfing'), findsOneWidget);
      expect(find.text('Travel & Destinations'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Failed zero-overflow check at width $width');
    }
  });

  testWidgets(
      'AlertsScreen renders active warnings with zero overflow across 320px and 360px devices',
      (WidgetTester tester) async {
    for (final width in [320.0, 360.0, 412.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AlertsScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Weather Alerts'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Failed zero-overflow check on AlertsScreen at width $width');
    }
  });

  testWidgets(
      'All 8 Specialized Domain Module Screens render with zero overflow across multiple device widths',
      (WidgetTester tester) async {
    for (final width in [320.0, 360.0, 412.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;

      final screens = <Widget>[
        const AgricultureScreen(),
        const CommuteScreen(),
        const EventScreen(),
        const FamilyScreen(),
        const FitnessScreen(),
        const HealthScreen(),
        const MarineScreen(),
        const TravelScreen(),
      ];

      for (final screen in screens) {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: screen,
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull,
            reason:
                'Failed zero-overflow check on ${screen.runtimeType} at width $width');
      }
    }
  });

  testWidgets(
      'RadarScreen renders interactive Doppler map, timeline, and controls with zero overflow',
      (WidgetTester tester) async {
    for (final width in [320.0, 360.0, 412.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const RadarScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(RadarScreen), findsOneWidget);
      expect(find.text('Rain / Precipitation'), findsOneWidget);
      expect(find.text('12:00 PM'), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Failed zero-overflow check on RadarScreen at width $width');
    }
  });

  testWidgets(
      'MausamModuleDrawer renders all 8 specialized modules with zero overflow across device widths',
      (WidgetTester tester) async {
    for (final width in [320.0, 360.0, 412.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              drawer: MausamModuleDrawer(),
              body: Center(child: Text('Home Content')),
            ),
          ),
        ),
      );

      // Open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('MAUSAM'), findsOneWidget);
      expect(find.text('SPECIALIZED MODULES'), findsOneWidget);
      expect(find.text('Health & AQI'), findsOneWidget);
      expect(find.text('Fitness & Running'), findsOneWidget);
      expect(find.text('Marine & Surfing'), findsOneWidget);
      expect(find.text('Travel & Destinations'), findsOneWidget);
      expect(find.text('Family & School'), findsOneWidget);
      expect(find.text('Agriculture & Farm'), findsOneWidget);
      expect(find.text('Commute'), findsOneWidget);
      expect(find.text('Event Planner'), findsOneWidget);

      expect(tester.takeException(), isNull,
          reason:
              'Failed zero-overflow check on MausamModuleDrawer at width $width');

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
    }
  });

  testWidgets(
      'Screens 33–41 Secondary Panels render with zero overflow across device widths',
      (WidgetTester tester) async {
    for (final width in [320.0, 360.0, 412.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;

      final secondaryScreens = <Widget>[
        const NotificationCenterScreen(),
        const NotificationSettingsScreen(),
        const UnitsScreen(),
        const LanguageScreen(),
        const HelpFeedbackScreen(),
        const AboutScreen(),
        const AodScreen(),
        const AppearanceScreen(),
      ];

      for (final screen in secondaryScreens) {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: screen,
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull,
            reason:
                'Failed zero-overflow check on ${screen.runtimeType} at width $width');
      }
    }
  });
}
