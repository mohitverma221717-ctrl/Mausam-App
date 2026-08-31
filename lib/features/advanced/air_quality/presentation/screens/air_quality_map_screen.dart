import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/air_quality/domain/repositories/air_quality_repository.dart';

class AirQualityMapScreen extends ConsumerWidget {
  const AirQualityMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqAsync = ref.watch(airQualityDataProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackgroundSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Air Quality Map & Metrics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: aqAsync.when(
        data: (aq) {
          final timeStr = DateFormat('h:mm a').format(aq.lastUpdated);

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(airQualityDataProvider);
            },
            color: AppColors.cyanAccent,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // AQI Meter Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        aq.categoryColor.withOpacity(0.35),
                        AppColors.darkBackgroundSecondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: aq.categoryColor.withOpacity(0.6)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AQI INDEX',
                                style: TextStyle(
                                  color: aq.categoryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${aq.aqi}',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: aq.categoryColor.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: aq.categoryColor),
                            ),
                            child: Text(
                              aq.category,
                              style: TextStyle(
                                color: aq.categoryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.darkBackground.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.health_and_safety_outlined,
                                color: aq.categoryColor, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                aq.healthAdvice,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Pollutant Breakdown
                const Text(
                  'Key Air Pollutants (µg/m³)',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPollutantCard(
                        'PM2.5',
                        '${aq.pm25}',
                        'Fine Particulate Matter',
                        Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPollutantCard(
                        'PM10',
                        '${aq.pm10}',
                        'Coarse Particulate Matter',
                        Colors.deepOrangeAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPollutantCard(
                        'NO₂',
                        '${aq.no2}',
                        'Nitrogen Dioxide',
                        Colors.purpleAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPollutantCard(
                        'O₃',
                        '${aq.o3}',
                        'Surface Ozone',
                        AppColors.cyanAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // AQI Scale Legend
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackgroundSecondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.glassBorder.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AQI Standard Scale',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildScaleItem(
                          '0 - 50', 'Good', const Color(0xFF10B981)),
                      _buildScaleItem(
                          '51 - 100', 'Moderate', const Color(0xFFF59E0B)),
                      _buildScaleItem('101 - 150', 'Unhealthy for Sensitive',
                          const Color(0xFFF97316)),
                      _buildScaleItem(
                          '151 - 200', 'Unhealthy', const Color(0xFFEF4444)),
                      _buildScaleItem('201 - 300', 'Very Unhealthy',
                          const Color(0xFFA855F7)),
                      _buildScaleItem(
                          '300+', 'Hazardous', const Color(0xFF881337)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DataSourceBadge(
                  source: aq.source,
                  lastUpdated: 'Updated at $timeStr',
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const AdvancedLoadingState(
          message: 'Fetching atmospheric air quality metrics...',
        ),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.refresh(airQualityDataProvider),
        ),
      ),
    );
  }

  Widget _buildPollutantCard(
      String name, String value, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleItem(String range, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(
              range,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
