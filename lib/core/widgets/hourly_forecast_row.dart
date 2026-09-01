import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';


class HourlyForecastRow extends StatefulWidget {
  final List<HourlyForecast> hourlyForecasts;
  final VoidCallback? onHeaderTap;
  final ValueChanged<HourlyForecast>? onItemTap;

  const HourlyForecastRow({
    super.key,
    required this.hourlyForecasts,
    this.onHeaderTap,
    this.onItemTap,
  });

  @override
  State<HourlyForecastRow> createState() => _HourlyForecastRowState();
}

class _HourlyForecastRowState extends State<HourlyForecastRow> {
  int _selectedIndex = 0;

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
                style: AppTypography.serifHeader.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
            ),
            if (widget.onHeaderTap != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: widget.onHeaderTap,
                child: Text(
                  'Full Forecast',
                  style: AppTypography.labelMedium.copyWith(
                    color: const Color(0xFF0284C7),
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
            itemCount: widget.hourlyForecasts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = widget.hourlyForecasts[index];
              final isSelected = index == _selectedIndex;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    if (widget.onItemTap != null) {
                      widget.onItemTap!(item);
                    }
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    width: 76,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? AppColors.primaryBlue.withOpacity(0.35)
                              : const Color(0xFFE0F2FE))
                          : (isDark
                              ? AppColors.darkSurfaceCard
                              : AppColors.lightSurfaceCard),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0284C7)
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0284C7).withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.time,
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected
                                ? (isDark ? AppColors.accentCyan : const Color(0xFF0284C7))
                                : (isDark
                                    ? AppColors.textDarkMuted
                                    : AppColors.textLightMuted),
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
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
                              ? const Color(0xFFF59E0B)
                              : (isDark
                                  ? AppColors.accentCyan
                                  : const Color(0xFF0284C7)),
                        ),
                        Text(
                          '${item.temperature.toInt()}°',
                          style: AppTypography.serifMetricValue.copyWith(
                            fontSize: 18,
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
                              color: Color(0xFF0284C7),
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
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


