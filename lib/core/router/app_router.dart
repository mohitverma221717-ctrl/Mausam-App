import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/mausam_bottom_nav.dart';

// Screens
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/get_started_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/legal_screens.dart';
import '../../features/location/presentation/screens/location_permission_screen.dart';
import '../../features/location/presentation/screens/select_location_screen.dart';
import '../../features/location/presentation/screens/map_location_picker_screen.dart';
import '../../features/location/presentation/screens/saved_locations_screen.dart';
import '../../features/personalization/presentation/screens/choose_interests_screen.dart';
import '../../features/personalization/presentation/screens/priority_setup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/radar/presentation/screens/radar_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/alerts/presentation/screens/alert_detail_screen.dart';
import '../../features/alerts/presentation/screens/notification_center_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/settings/presentation/screens/units_screen.dart';
import '../../features/settings/presentation/screens/language_screen.dart';
import '../../features/settings/presentation/screens/appearance_screen.dart';
import '../../features/settings/presentation/screens/notification_settings_screen.dart';
import '../../features/settings/presentation/screens/about_screen.dart';
import '../../features/settings/presentation/screens/help_feedback_screen.dart';
import '../../features/settings/presentation/screens/aod_screen.dart';
import '../../features/weather/presentation/screens/weather_details_screen.dart';
import '../../features/forecast/presentation/screens/hourly_forecast_screen.dart';
import '../../features/forecast/presentation/screens/daily_forecast_screen.dart';

// Specialized Modules
import '../../features/modules/health/presentation/screens/health_screen.dart';
import '../../features/modules/fitness/presentation/screens/fitness_screen.dart';
import '../../features/modules/marine/presentation/screens/marine_screen.dart';
import '../../features/modules/travel/presentation/screens/travel_screen.dart';
import '../../features/modules/family/presentation/screens/family_screen.dart';
import '../../features/modules/agriculture/presentation/screens/agriculture_screen.dart';
import '../../features/modules/commute/presentation/screens/commute_screen.dart';
import '../../features/modules/events/presentation/screens/event_screen.dart';

// Advanced Weather Intelligence & Earth Monitoring Screens
import '../../features/advanced/disaster/presentation/screens/disaster_hub_screen.dart';
import '../../features/advanced/disaster/presentation/screens/disaster_detail_screen.dart';
import '../../features/advanced/cyclone/presentation/screens/cyclone_tracker_screen.dart';
import '../../features/advanced/earthquake/presentation/screens/earthquake_screen.dart';
import '../../features/advanced/lightning/presentation/screens/lightning_monitor_screen.dart';
import '../../features/advanced/air_quality/presentation/screens/air_quality_map_screen.dart';
import '../../features/advanced/nowcast/presentation/screens/weather_nowcast_screen.dart';
import '../../features/advanced/earth/presentation/screens/live_earth_screen.dart';
import '../../features/advanced/ai_assistant/presentation/screens/mausam_ai_assistant_screen.dart';
import '../../features/advanced/smart_route/presentation/screens/smart_route_weather_screen.dart';
import '../../features/advanced/event_intelligence/presentation/screens/event_intelligence_screen.dart';
import '../../features/advanced/weather_widgets/presentation/screens/weather_widgets_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHome =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorExplore =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorRadar =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorAlerts =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorProfile =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/get-started',
      builder: (context, state) => const GetStartedScreen(),
    ),

    // Authentication Routes
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/auth/otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/auth/terms',
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: '/auth/privacy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),

    // Location Routes
    GoRoute(
      path: '/location/permission',
      builder: (context, state) => const LocationPermissionScreen(),
    ),
    GoRoute(
      path: '/locations/select',
      builder: (context, state) => const SelectLocationScreen(),
    ),
    GoRoute(
      path: '/locations/map-picker',
      builder: (context, state) => const MapLocationPickerScreen(),
    ),
    GoRoute(
      path: '/locations/manage',
      builder: (context, state) => const SavedLocationsScreen(),
    ),

    // Personalization Routes
    GoRoute(
      path: '/personalization/interests',
      builder: (context, state) => const ChooseInterestsScreen(),
    ),
    GoRoute(
      path: '/personalization/priority',
      builder: (context, state) => const PrioritySetupScreen(),
    ),

    // Weather & Forecast Detail Views
    GoRoute(
      path: '/weather/details',
      builder: (context, state) => const WeatherDetailsScreen(),
    ),
    GoRoute(
      path: '/forecast/hourly',
      builder: (context, state) => const HourlyForecastScreen(),
    ),
    GoRoute(
      path: '/forecast/daily',
      builder: (context, state) => const DailyForecastScreen(),
    ),

    // Alerts & Notifications
    GoRoute(
      path: '/alerts/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'alert-1';
        return AlertDetailScreen(alertId: id);
      },
    ),
    GoRoute(
      path: '/alerts/notifications',
      builder: (context, state) => const NotificationCenterScreen(),
    ),

    // Profile & Settings Deep Dive Sub-routes
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/profile/units',
      builder: (context, state) => const UnitsScreen(),
    ),
    GoRoute(
      path: '/profile/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/profile/appearance',
      builder: (context, state) => const AppearanceScreen(),
    ),
    GoRoute(
      path: '/profile/notifications',
      builder: (context, state) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/profile/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/profile/help',
      builder: (context, state) => const HelpFeedbackScreen(),
    ),
    GoRoute(
      path: '/profile/aod',
      builder: (context, state) => const AodScreen(),
    ),

    // Specialized Domain Modules Sub-routes
    GoRoute(
      path: '/explore/health',
      builder: (context, state) => const HealthScreen(),
    ),
    GoRoute(
      path: '/explore/fitness',
      builder: (context, state) => const FitnessScreen(),
    ),
    GoRoute(
      path: '/explore/marine',
      builder: (context, state) => const MarineScreen(),
    ),
    GoRoute(
      path: '/explore/travel',
      builder: (context, state) => const TravelScreen(),
    ),
    GoRoute(
      path: '/explore/family',
      builder: (context, state) => const FamilyScreen(),
    ),
    GoRoute(
      path: '/explore/agriculture',
      builder: (context, state) => const AgricultureScreen(),
    ),
    GoRoute(
      path: '/explore/commute',
      builder: (context, state) => const CommuteScreen(),
    ),
    GoRoute(
      path: '/explore/event-planner',
      builder: (context, state) => const EventScreen(),
    ),

    // Advanced Weather Intelligence & Earth Monitoring Routes
    GoRoute(
      path: '/advanced/disaster-hub',
      builder: (context, state) => const DisasterHubScreen(),
    ),
    GoRoute(
      path: '/advanced/disaster/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'disaster-1';
        return DisasterDetailScreen(disasterId: id);
      },
    ),
    GoRoute(
      path: '/advanced/cyclone-tracker',
      builder: (context, state) => const CycloneTrackerScreen(),
    ),
    GoRoute(
      path: '/advanced/earthquake-monitor',
      builder: (context, state) => const EarthquakeScreen(),
    ),
    GoRoute(
      path: '/advanced/lightning-monitor',
      builder: (context, state) => const LightningMonitorScreen(),
    ),
    GoRoute(
      path: '/advanced/air-quality-map',
      builder: (context, state) => const AirQualityMapScreen(),
    ),
    GoRoute(
      path: '/advanced/nowcast',
      builder: (context, state) => const WeatherNowcastScreen(),
    ),
    GoRoute(
      path: '/advanced/live-earth',
      builder: (context, state) => const LiveEarthScreen(),
    ),
    GoRoute(
      path: '/advanced/ai-assistant',
      builder: (context, state) => const MausamAiAssistantScreen(),
    ),
    GoRoute(
      path: '/advanced/smart-route',
      builder: (context, state) => const SmartRouteWeatherScreen(),
    ),
    GoRoute(
      path: '/advanced/event-planner',
      builder: (context, state) => const EventIntelligenceScreen(),
    ),
    GoRoute(
      path: '/advanced/widgets-setup',
      builder: (context, state) => const WeatherWidgetsScreen(),
    ),

    // Main App Shell with 5 Bottom Navigation Branches
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar:
              MausamBottomNav(navigationShell: navigationShell),
        );
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHome,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 2: Explore
        StatefulShellBranch(
          navigatorKey: _shellNavigatorExplore,
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),

        // Tab 3: Radar
        StatefulShellBranch(
          navigatorKey: _shellNavigatorRadar,
          routes: [
            GoRoute(
              path: '/radar',
              builder: (context, state) => const RadarScreen(),
            ),
          ],
        ),

        // Tab 4: Alerts
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAlerts,
          routes: [
            GoRoute(
              path: '/alerts',
              builder: (context, state) => const AlertsScreen(),
            ),
          ],
        ),

        // Tab 5: Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfile,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
