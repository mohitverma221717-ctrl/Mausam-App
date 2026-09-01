import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_app_bar.dart';
import '../../../../core/widgets/mausam_module_drawer.dart';
import '../../../../core/widgets/weather_hero_card.dart';
import '../../../../core/widgets/weather_metric_tile.dart';
import '../../../../core/widgets/hourly_forecast_row.dart';
import '../../../../core/widgets/hourly_forecast_detail_sheet.dart';
import '../../../../core/widgets/daily_forecast_tile.dart';
import '../../../../core/widgets/personalized_recommendation_card.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/weather_3d_background_layer.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../alerts/presentation/providers/alerts_provider.dart';
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
      body: Weather3dBackgroundLayer(
        child: RefreshIndicator(
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
              // Active Weather Alert Banner (Matching Screenshot 1)
              if (activeAlert != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3A1A1A)
                        : const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF5C2626)
                          : const Color(0xFFF87171).withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.push('/alerts'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF4C1D1D)
                                  : const Color(0xFFFCA5A5).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFDC2626),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeAlert.title,
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${activeAlert.timeRange} · carry cover if out late',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? const Color(0xFFFCA5A5)
                                        : const Color(0xFF991B1B),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 22,
                            color: isDark
                                ? const Color(0xFFFCA5A5)
                                : const Color(0xFFB91C1C),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // Main Hero Weather Card
              WeatherHeroCard(
                weather: weather,
                onTap: () => context.push('/weather/details'),
              ),
              const SizedBox(height: 16),

              // Quick Metrics 2x2 Grid (Matching Screenshot 1)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.22,
                children: [
                  WeatherMetricTile(
                    title: 'Air quality',
                    value: '${weather.aqi} ${weather.aqiStatus}',
                    subtitle: 'PM2.5 · 25 µg/m³',
                    icon: Icons.air_rounded,
                    accentColor: AppColors.statusSuccess,
                    progress: 0.25,
                    onTap: () => context.push('/explore/health'),
                  ),
                  WeatherMetricTile(
                    title: 'UV index',
                    value: '${weather.uvIndex} Moderate',
                    subtitle: 'SPF 30+ from 11am',
                    icon: Icons.wb_sunny_outlined,
                    accentColor: AppColors.statusWarning,
                    progress: 0.5,
                    onTap: () => context.push('/explore/health'),
                  ),
                  WeatherMetricTile(
                    title: 'Humidity',
                    value: '${weather.humidity}%',
                    subtitle: 'Sticky, expect haze by dusk',
                    icon: Icons.water_drop_outlined,
                    accentColor: const Color(0xFF0284C7),
                    progress: 0.68,
                    onTap: () => context.push('/weather/details'),
                  ),
                  WeatherMetricTile(
                    title: 'Wind',
                    value: '${weather.windSpeed.toInt()} km/h',
                    subtitle: 'From the northeast',
                    icon: Icons.navigation_rounded,
                    accentColor: const Color(0xFF64748B),
                    progress: 0.35,
                    onTap: () => context.push('/weather/details'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // "Health today" Quick Strip (Matching Screenshot 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Health today',
                    style: AppTypography.serifHeader.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.push('/explore/health'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            'Full dashboard',
                            style: AppTypography.labelMedium.copyWith(
                              color: const Color(0xFF0284C7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Color(0xFF0284C7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Health Metrics Horizontal Pills (Screenshot 2)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildHealthPill(
                      context,
                      label: 'AQI',
                      value: '${weather.aqi}',
                      color: AppColors.statusSuccess,
                      isDark: isDark,
                    ),
                    _buildHealthPill(
                      context,
                      label: 'UV',
                      value: '${weather.uvIndex}',
                      color: AppColors.statusWarning,
                      isDark: isDark,
                    ),
                    _buildHealthPill(
                      context,
                      label: 'Humidity',
                      value: '${weather.humidity}%',
                      color: const Color(0xFF0284C7),
                      isDark: isDark,
                    ),
                    _buildHealthPill(
                      context,
                      label: 'Pollen',
                      value: 'Low',
                      color: AppColors.statusSuccess,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Advanced Weather Intelligence Quick Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced Intelligence',
                    style: AppTypography.serifHeader.copyWith(
                      fontWeight: FontWeight.w700,
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
                        color: const Color(0xFF0284C7),
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
                      isDark: isDark,
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Disaster Hub',
                      icon: Icons.health_and_safety_rounded,
                      color: const Color(0xFFDC2626),
                      route: '/advanced/disaster-hub',
                      isDark: isDark,
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Mausam AI',
                      icon: Icons.smart_toy_rounded,
                      color: const Color(0xFF3B82F6),
                      route: '/advanced/ai-assistant',
                      isDark: isDark,
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Cyclone',
                      icon: Icons.cyclone,
                      color: const Color(0xFFEF4444),
                      route: '/advanced/cyclone-tracker',
                      isDark: isDark,
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Nowcast',
                      icon: Icons.umbrella_rounded,
                      color: const Color(0xFF0284C7),
                      route: '/advanced/nowcast',
                      isDark: isDark,
                    ),
                    _buildHomeQuickAction(
                      context,
                      title: 'Earthquake',
                      icon: Icons.vibration_rounded,
                      color: const Color(0xFFF59E0B),
                      route: '/advanced/earthquake-monitor',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Hourly Forecast Strip
              HourlyForecastRow(
                hourlyForecasts: weatherState.hourlyForecast,
                onHeaderTap: () => context.push('/forecast/hourly'),
                onItemTap: (forecast) =>
                    HourlyForecastDetailSheet.show(context, forecast),
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
                      style: AppTypography.serifHeader.copyWith(
                        fontWeight: FontWeight.w700,
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
                        color: const Color(0xFF0284C7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Render dynamically scored cards (Running window & Agriculture cards matching Screenshot 2)
              if (personalizationState.personalizedCards.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    borderRadius: BorderRadius.circular(20),
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

            ],
          ),
        ),
      ),
    ),
  );
}



  Widget _buildHealthPill(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      width: 86,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textDarkMuted
                  : AppColors.textLightMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeQuickAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

