import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/weather_chart.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/domain/models/weather_data.dart';

class HourlyForecastScreen extends ConsumerWidget {
  const HourlyForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Hourly Forecast'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Temperature Spline Chart
            WeatherTemperatureChart(hourlyList: weatherState.hourlyForecast),
            const SizedBox(height: 24),

            Text(
              'Hourly Timeline',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weatherState.hourlyForecast.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = weatherState.hourlyForecast[index];

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    borderRadius: AppRadius.brLg,
                    border: Border.all(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          item.time,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        item.conditionType == WeatherConditionType.sunny
                            ? Icons.wb_sunny_rounded
                            : (item.conditionType == WeatherConditionType.rainy
                                ? Icons.grain_rounded
                                : Icons.cloud_rounded),
                        size: 24,
                        color: item.conditionType == WeatherConditionType.sunny
                            ? const Color(0xFFFFB300)
                            : AppColors.accentCyan,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.condition,
                              style: AppTypography.titleSmall.copyWith(
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.water_drop_rounded,
                                    size: 12, color: AppColors.primaryBlue),
                                const SizedBox(width: 2),
                                Text(
                                  '${item.rainProbability}% Rain',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isDark
                                        ? AppColors.textDarkSecondary
                                        : AppColors.textLightSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Wind: ${item.windSpeed.toInt()} km/h',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isDark
                                        ? AppColors.textDarkMuted
                                        : AppColors.textLightMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${item.temperature.toInt()}°C',
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
