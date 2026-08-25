import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/domain/models/weather_data.dart';

class DailyForecastScreen extends ConsumerWidget {
  const DailyForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final forecastList = weatherState.extendedForecast.isNotEmpty
        ? weatherState.extendedForecast
        : weatherState.dailyForecast;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('15-Day Extended Outlook'),
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
            // Accuracy & Data Source Disclaimer Banner per specification
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.12),
                borderRadius: AppRadius.brMd,
                border:
                    Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.accentCyan, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Forecast availability and precision depend on official meteorological numerical models (IMD GFS / ECMWF). Forecasts beyond 7 days reflect broader atmospheric trends.',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: forecastList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = forecastList[index];

                return Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.dayName,
                                style: AppTypography.titleLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textDarkPrimary
                                      : AppColors.textLightPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${item.date.day}/${item.date.month}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.textDarkMuted
                                      : AppColors.textLightMuted,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                item.conditionType == WeatherConditionType.sunny
                                    ? Icons.wb_sunny_rounded
                                    : (item.conditionType ==
                                            WeatherConditionType.thunderstorm
                                        ? Icons.flash_on_rounded
                                        : (item.conditionType ==
                                                WeatherConditionType.rainy
                                            ? Icons.grain_rounded
                                            : Icons.cloud_rounded)),
                                size: 20,
                                color: item.conditionType ==
                                        WeatherConditionType.sunny
                                    ? const Color(0xFFFFB300)
                                    : AppColors.accentCyan,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.condition,
                                style: AppTypography.titleSmall.copyWith(
                                  color: isDark
                                      ? AppColors.textDarkPrimary
                                      : AppColors.textLightPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'High: ${item.tempMax.toInt()}°C',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFF7043),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Low: ${item.tempMin.toInt()}°C',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentCyan,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.water_drop_rounded,
                                  size: 14, color: AppColors.primaryBlue),
                              const SizedBox(width: 2),
                              Text(
                                '${item.rainProbability}% Rain',
                                style: AppTypography.labelSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLightSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.summary,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textDarkMuted
                              : AppColors.textLightMuted,
                          fontSize: 12,
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
