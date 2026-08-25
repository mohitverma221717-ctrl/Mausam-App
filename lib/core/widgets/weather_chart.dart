import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';

class WeatherTemperatureChart extends StatelessWidget {
  final List<HourlyForecast> hourlyList;

  const WeatherTemperatureChart({
    super.key,
    required this.hourlyList,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spots = hourlyList.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.temperature);
    }).toList();

    double minTemp =
        hourlyList.map((e) => e.temperature).reduce((a, b) => a < b ? a : b) -
            2;
    double maxTemp =
        hourlyList.map((e) => e.temperature).reduce((a, b) => a > b ? a : b) +
            2;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 20, 12),
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
              Text(
                'Temperature Trend',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.15),
                  borderRadius: AppRadius.brSm,
                ),
                child: Text(
                  'Next 12 Hours',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                minY: minTemp,
                maxY: maxTemp,
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 &&
                            idx < hourlyList.length &&
                            idx % 2 == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              hourlyList[idx].time,
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark
                                    ? AppColors.textDarkMuted
                                    : AppColors.textLightMuted,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.accentCyan,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primaryBlue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.accentCyan.withOpacity(0.3),
                          AppColors.primaryBlue.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
