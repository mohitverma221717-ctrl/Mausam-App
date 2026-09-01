import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';

class HourlyForecastDetailSheet extends StatelessWidget {
  final HourlyForecast forecast;

  const HourlyForecastDetailSheet({
    super.key,
    required this.forecast,
  });

  static Future<void> show(BuildContext context, HourlyForecast forecast) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HourlyForecastDetailSheet(forecast: forecast),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final conditionIcon = forecast.conditionType == WeatherConditionType.sunny
        ? Icons.wb_sunny_rounded
        : (forecast.conditionType == WeatherConditionType.rainy
            ? Icons.grain_rounded
            : Icons.cloud_rounded);

    final conditionColor = forecast.conditionType == WeatherConditionType.sunny
        ? const Color(0xFFFFB300)
        : AppColors.accentCyan;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header: Time & Condition
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: conditionColor.withOpacity(0.15),
                  borderRadius: AppRadius.brLg,
                ),
                child: Icon(conditionIcon, size: 36, color: conditionColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forecast for ${forecast.time}',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      forecast.condition,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${forecast.temperature.toInt()}°C',
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Detailed metrics grid
          Row(
            children: [
              Expanded(
                child: _buildMetricBox(
                  context,
                  title: 'Rain Probability',
                  value: '${forecast.rainProbability}%',
                  icon: Icons.water_drop_rounded,
                  color: AppColors.primaryBlue,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricBox(
                  context,
                  title: 'Wind Speed',
                  value: '${forecast.windSpeed.toInt()} km/h',
                  icon: Icons.air_rounded,
                  color: AppColors.accentCyan,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricBox(
                  context,
                  title: 'Humidity',
                  value: '${forecast.humidity}%',
                  icon: Icons.compress_rounded,
                  color: AppColors.accentIndigo,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weather Advisory Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceCard
                  : AppColors.lightSurfaceCard,
              borderRadius: AppRadius.brLg,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    forecast.rainProbability > 30
                        ? 'High chance of precipitation around ${forecast.time}. Keep an umbrella handy!'
                        : 'Favorable outdoor weather expected around ${forecast.time}.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.brLg,
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/forecast/hourly');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.brLg,
                    ),
                  ),
                  child: Text(
                    'Full Forecast',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: AppRadius.brMd,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              fontSize: 10,
              color: isDark
                  ? AppColors.textDarkMuted
                  : AppColors.textLightMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
