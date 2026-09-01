import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/weather_hero_card.dart';
import '../../../../core/widgets/weather_chart.dart';
import '../../../../core/widgets/weather_3d_background_layer.dart';
import '../providers/weather_provider.dart';

class WeatherDetailsScreen extends ConsumerWidget {
  const WeatherDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (weatherState.currentWeather == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weather Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final weather = weatherState.currentWeather!;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text('${weather.cityName} Weather Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Weather3dBackgroundLayer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WeatherHeroCard(weather: weather),
              const SizedBox(height: 20),

              // Temperature Curve Chart
              WeatherTemperatureChart(hourlyList: weatherState.hourlyForecast),
              const SizedBox(height: 20),

              Text(
                'Atmospheric & Climate Metrics',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Deep Dive Detail Cards
              _DetailTile(
                title: 'Humidity & Dew Point',
                value: '${weather.humidity}% Humidity',
                detail:
                    'Dew point is 21°C. Relative moisture is balanced for comfortable respiration.',
                icon: Icons.water_drop_rounded,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 12),

              _DetailTile(
                title: 'Wind & Gusts',
                value:
                    '${weather.windSpeed.toInt()} km/h (${weather.windDirection})',
                detail:
                    'Gentle breeze. Peak gusts estimated at 22 km/h around open highway sectors.',
                icon: Icons.air_rounded,
                color: AppColors.accentCyan,
              ),
              const SizedBox(height: 12),

              _DetailTile(
                title: 'Barometric Pressure',
                value: '${weather.pressure} hPa',
                detail:
                    'Steady barometric pressure indicates continuous stable atmospheric conditions.',
                icon: Icons.compress_rounded,
                color: AppColors.accentIndigo,
              ),
              const SizedBox(height: 12),

              _DetailTile(
                title: 'Cloud Cover & Visibility',
                value:
                    '${weather.cloudCover}% Cloudiness • ${weather.visibility.toInt()} km Visibility',
                detail:
                    'High altitude cirrus and cumulus clouds. Clear sightlines for road and air travel.',
                icon: Icons.visibility_rounded,
                color: AppColors.statusSuccess,
              ),
              const SizedBox(height: 12),

              _DetailTile(
                title: 'Solar & Daylight Cycle',
                value: 'Sunrise: ${weather.sunrise} • Sunset: ${weather.sunset}',
                detail:
                    'Daylight duration: 12 hrs 42 mins. Peak UV index expected at 12:45 PM.',
                icon: Icons.wb_twilight_rounded,
                color: const Color(0xFFFF9100),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  const _DetailTile({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
        borderRadius: AppRadius.brLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: AppRadius.brMd,
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textDarkMuted
                        : AppColors.textLightMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
