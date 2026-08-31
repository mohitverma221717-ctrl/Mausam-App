import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/mausam_app_bar.dart';
import '../../../../core/widgets/mausam_module_drawer.dart';
import '../../../../core/widgets/weather_hero_card.dart';
import '../../../../core/widgets/weather_metric_tile.dart';
import '../../../../core/widgets/hourly_forecast_row.dart';
import '../../../../core/widgets/daily_forecast_tile.dart';
import '../../../../core/widgets/personalized_recommendation_card.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../alerts/presentation/providers/alerts_provider.dart';
import '../../../alerts/domain/models/weather_alert.dart';
import '../../../personalization/presentation/providers/personalization_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final alertsState = ref.watch(alertsProvider);
    final personalizationState = ref.watch(personalizationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (weatherState.isLoading && weatherState.currentWeather == null) {
      return const Scaffold(
        appBar: MausamAppBar(),
        drawer: MausamModuleDrawer(),
        body: SingleChildScrollView(child: WeatherSkeletonView()),
      );
    }

    if (weatherState.errorMessage != null &&
        weatherState.currentWeather == null) {
      return Scaffold(
        appBar: const MausamAppBar(),
        drawer: const MausamModuleDrawer(),
        body: ErrorStateView(
          message: weatherState.errorMessage!,
          onRetry: () => ref.read(weatherProvider.notifier).fetchWeather(),
        ),
      );
    }

    final weather = weatherState.currentWeather!;
    final activeAlert = alertsState.activeAlerts.isNotEmpty
        ? alertsState.activeAlerts.first
        : null;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const MausamAppBar(),
      drawer: const MausamModuleDrawer(),
      body: RefreshIndicator(
        color: AppColors.primaryBlue,
        backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
        onRefresh: () async {
          await ref
              .read(weatherProvider.notifier)
              .fetchWeather(isRefresh: true);
          await ref.read(alertsProvider.notifier).loadAlerts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Weather Alert Banner
              if (activeAlert != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: activeAlert.severity.color.withOpacity(0.15),
                    borderRadius: AppRadius.brLg,
                    border: Border.all(
                      color: activeAlert.severity.color.withOpacity(0.5),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => context.push('/alerts'),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: activeAlert.severity.color,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeAlert.title,
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textLightPrimary,
                                ),
                              ),
                              Text(
                                activeAlert.timeRange,
                                style: AppTypography.bodySmall.copyWith(
                                  color: activeAlert.severity.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.textDarkMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Main Hero Weather Card
              WeatherHeroCard(
                weather: weather,
                onTap: () => context.push('/weather/details'),
              ),
              const SizedBox(height: 20),

              // Quick Metrics 2x3 Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.36,
                children: [
                  WeatherMetricTile(
                    title: 'Air Quality (AQI)',
                    value: '${weather.aqi} • ${weather.aqiStatus}',
                    subtitle: 'PM2.5: 25 µg/m³',
                    icon: Icons.air_rounded,
                    accentColor: AppColors.statusSuccess,
                    progress: 0.25,
                    onTap: () => context.push('/explore/health'),
                  ),
                  WeatherMetricTile(
                    title: 'UV Index',
                    value: '${weather.uvIndex} Moderate',
                    subtitle: 'SPF 30+ recommended',
                    icon: Icons.wb_sunny_outlined,
                    accentColor: AppColors.statusWarning,
                    progress: 0.5,
                    onTap: () => context.push('/explore/health'),
                  ),
                  WeatherMetricTile(
                    title: 'Humidity',
                    value: '${weather.humidity}%',
                    subtitle: 'Dew point 21°C',
                    icon: Icons.water_drop_outlined,
                    accentColor: AppColors.primaryBlue,
                    progress: 0.68,
                    onTap: () => context.push('/weather/details'),
                  ),
                  WeatherMetricTile(
                    title: 'Wind Speed',
                    value: '${weather.windSpeed.toInt()} km/h',
                    subtitle: 'Direction: ${weather.windDirection}',
                    icon: Icons.navigation_rounded,
                    accentColor: AppColors.accentCyan,
                    progress: 0.35,
                    onTap: () => context.push('/weather/details'),
                  ),
                  WeatherMetricTile(
                    title: 'Pressure',
                    value: '${weather.pressure} hPa',
                    subtitle: 'Standard atmospheric',
                    icon: Icons.compress_rounded,
                    accentColor: AppColors.accentIndigo,
                    onTap: () => context.push('/weather/details'),
                  ),
                  WeatherMetricTile(
                    title: 'Sun Cycle',
                    value: weather.sunrise,
                    subtitle: 'Sunset: ${weather.sunset}',
                    icon: Icons.wb_twilight_rounded,
                    accentColor: const Color(0xFFFF9100),
                    onTap: () => context.push('/weather/details'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Advanced Weather Intelligence Quick Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced Intelligence',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/explore'),
                    child: Text(
                      'View All',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildHomeQuickAction(
                      context,
                      title: 'Live Earth',
                      icon: Icons.public_rounded,
                      color: const Color(0xFF06B6D4),
                      route: '/advanced/live-earth',
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Disaster Hub',
                      icon: Icons.health_and_safety_rounded,
                      color: const Color(0xFFDC2626),
                      route: '/advanced/disaster-hub',
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Mausam AI',
                      icon: Icons.smart_toy_rounded,
                      color: const Color(0xFF3B82F6),
                      route: '/advanced/ai-assistant',
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Cyclone',
                      icon: Icons.cyclone,
                      color: const Color(0xFFEF4444),
                      route: '/advanced/cyclone-tracker',
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Nowcast',
                      icon: Icons.umbrella_rounded,
                      color: const Color(0xFF0284C7),
                      route: '/advanced/nowcast',
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Earthquake',
                      icon: Icons.vibration_rounded,
                      color: const Color(0xFFF59E0B),
                      route: '/advanced/earthquake-monitor',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Hourly Forecast Strip
              HourlyForecastRow(
                hourlyForecasts: weatherState.hourlyForecast,
                onHeaderTap: () => context.push('/forecast/hourly'),
              ),
              const SizedBox(height: 24),

              // 7-Day Forecast Card
              DailyForecastCard(
                dailyForecasts: weatherState.dailyForecast,
              ),
              const SizedBox(height: 28),

              // "Recommended for You" - Dynamic Personalized Weather Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Recommended for You',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => context.push('/personalization/interests'),
                    child: Text(
                      'Customize',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Render dynamically scored cards
              if (personalizationState.personalizedCards.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    borderRadius: AppRadius.brLg,
                  ),
                  child: Center(
                    child: Text(
                      'No personalized insights yet. Tap customize to select interests.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                )
              else
                ...personalizationState.personalizedCards.map(
                  (cardData) => PersonalizedRecommendationCard(data: cardData),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeQuickAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.darkBackgroundSecondary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
