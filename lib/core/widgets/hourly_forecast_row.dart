import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';

class HourlyForecastRow extends StatelessWidget {
  final List<HourlyForecast> hourlyForecasts;
  final VoidCallback? onHeaderTap;

  const HourlyForecastRow({
    super.key,
    required this.hourlyForecasts,
    this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Hourly Forecast',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
            ),
            if (onHeaderTap != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onHeaderTap,
                child: Text(
                  'Full Forecast',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 142,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecasts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = hourlyForecasts[index];
              final isCurrent = index == 0;

              return Container(
                width: 76,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? (isDark
                          ? AppColors.primaryBlue.withOpacity(0.25)
                          : AppColors.primaryBlue.withOpacity(0.12))
                      : (isDark
                          ? AppColors.darkSurfaceCard
                          : AppColors.lightSurfaceCard),
                  borderRadius: AppRadius.brLg,
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.primaryBlue
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: isCurrent ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.time,
                      style: AppTypography.labelSmall.copyWith(
                        color: isCurrent
                            ? AppColors.accentCyan
                            : (isDark
                                ? AppColors.textDarkMuted
                                : AppColors.textLightMuted),
                        fontWeight:
                            isCurrent ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    Icon(
                      item.conditionType == WeatherConditionType.sunny
                          ? Icons.wb_sunny_rounded
                          : (item.conditionType == WeatherConditionType.rainy
                              ? Icons.grain_rounded
                              : Icons.cloud_rounded),
                      size: 26,
                      color: item.conditionType == WeatherConditionType.sunny
                          ? const Color(0xFFFFB300)
                          : (isDark
                              ? AppColors.accentCyan
                              : AppColors.primaryBlue),
                    ),
                    Text(
                      '${item.temperature.toInt()}°',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 10,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${item.rainProbability}%',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
