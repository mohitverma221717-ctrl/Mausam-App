import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../presentation/providers/module_providers.dart';

class FitnessScreen extends ConsumerWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fitnessAsync = ref.watch(fitnessDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Fitness & Running'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: fitnessAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading fitness data: $err')),
        data: (fitness) {
          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Best Running Hours Hero Banner
                Container(
                  padding: const EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    borderRadius: AppRadius.brXl,
                    border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFFF9100).withOpacity(0.18),
                                borderRadius: AppRadius.brPill,
                              ),
                              child: Text(
                                fitness.overallSuitability,
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFFFF9100),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Best Running Hours',
                              style: AppTypography.labelMedium.copyWith(
                                color: isDark
                                    ? AppColors.textDarkMuted
                                    : AppColors.textLightMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              fitness.bestRunningHours,
                              style: AppTypography.headlineSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fitness.activitySuggestion,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textLightSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF9100).withOpacity(0.15),
                        ),
                        child: const Icon(
                          Icons.directions_run_rounded,
                          size: 40,
                          color: Color(0xFFFF9100),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Heat Index & Activity Metrics
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                  children: [
                    _FitnessMetricCard(
                      title: 'Heat Index',
                      value: '${fitness.heatIndex.toInt()}°C',
                      subtitle: fitness.heatRisk,
                      color: AppColors.statusWarning,
                    ),
                    _FitnessMetricCard(
                      title: 'UV Index',
                      value: '${fitness.uvIndex}',
                      subtitle: 'Moderate',
                      color: const Color(0xFFFF9100),
                    ),
                    _FitnessMetricCard(
                      title: 'Wind Speed',
                      value: '${fitness.windSpeed.toInt()} km/h',
                      subtitle: 'Light Breeze',
                      color: AppColors.accentCyan,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Running Planner Timeline
                Text(
                  'Workout Windows Planner',
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
                  itemCount: fitness.hourlyWindows.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final window = fitness.hourlyWindows[index];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceCard
                            : AppColors.lightSurfaceCard,
                        borderRadius: AppRadius.brLg,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      window.timeRange,
                                      style: AppTypography.titleMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? AppColors.textDarkPrimary
                                            : AppColors.textLightPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: window.qualityColor
                                            .withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        window.quality,
                                        style: TextStyle(
                                          color: window.qualityColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  window.note,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.textDarkMuted
                                        : AppColors.textLightMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${window.temp.toInt()}°C',
                                style: AppTypography.titleLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textDarkPrimary
                                      : AppColors.textLightPrimary,
                                ),
                              ),
                              Text(
                                '${window.wind.toInt()} km/h wind',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark
                                      ? AppColors.textDarkMuted
                                      : AppColors.textLightMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Sports Suitability Breakdown
                Text(
                  'Sport Suitability Breakdown',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    borderRadius: AppRadius.brLg,
                    border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                  ),
                  child: Column(
                    children: fitness.activityRatings.entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.key,
                              style: AppTypography.titleMedium.copyWith(
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.statusSuccess.withOpacity(0.18),
                                borderRadius: AppRadius.brPill,
                              ),
                              child: Text(
                                e.value,
                                style: const TextStyle(
                                  color: AppColors.statusSuccess,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FitnessMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _FitnessMetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
        borderRadius: AppRadius.brMd,
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color:
                  isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.textLightPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
