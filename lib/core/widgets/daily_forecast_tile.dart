import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';

class DailyForecastCard extends StatefulWidget {
  final List<DailyForecast> dailyForecasts;

  const DailyForecastCard({
    super.key,
    required this.dailyForecasts,
  });

  @override
  State<DailyForecastCard> createState() => _DailyForecastCardState();
}

class _DailyForecastCardState extends State<DailyForecastCard> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
        borderRadius: AppRadius.brXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '7-Day Forecast',
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
              const SizedBox(width: 8),
              const Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: AppColors.accentCyan,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.dailyForecasts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = widget.dailyForecasts[index];
              final isExpanded = _expandedIndex == index;

              return InkWell(
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 65,
                            child: Text(
                              item.dayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.titleMedium.copyWith(
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                                fontWeight: index == 0
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
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
                            size: 22,
                            color:
                                item.conditionType == WeatherConditionType.sunny
                                    ? const Color(0xFFFFB300)
                                    : (isDark
                                        ? AppColors.accentCyan
                                        : AppColors.primaryBlue),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.water_drop_rounded,
                                size: 12,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${item.rainProbability}%',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLightSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.tempMax.toInt()}°',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textDarkPrimary
                                      : AppColors.textLightPrimary,
                                ),
                              ),
                              Text(
                                ' / ${item.tempMin.toInt()}°',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.textDarkMuted
                                      : AppColors.textLightMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.lightBackgroundSecondary,
                            borderRadius: AppRadius.brSm,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.summary,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.textDarkSecondary
                                        : AppColors.textLightSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Wind: ${item.windSpeed.toInt()} km/h',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primaryBlueLight,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    'UV Index: ${item.uvIndex}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.statusWarning,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
