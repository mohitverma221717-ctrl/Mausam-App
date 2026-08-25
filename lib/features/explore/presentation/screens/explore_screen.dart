import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../personalization/domain/models/personalization_models.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const modules = [
      _ModuleItem(
        interest: UserInterest.health,
        title: 'Health & AQI',
        description:
            'Air quality index, tree/grass pollen, UV protection & respiratory advisories.',
        metric: 'AQI 82 • Good',
        route: '/explore/health',
      ),
      _ModuleItem(
        interest: UserInterest.fitness,
        title: 'Fitness & Running',
        description:
            'Best workout hours, heat stress index, outdoor running suitability.',
        metric: '6:00 – 8:00 AM Optimal',
        route: '/explore/fitness',
      ),
      _ModuleItem(
        interest: UserInterest.marine,
        title: 'Marine & Surfing',
        description:
            'High/low tide charts, wave height, swell period & coastal boating safety.',
        metric: 'Sea: Good • 1.2m Wave',
        route: '/explore/marine',
      ),
      _ModuleItem(
        interest: UserInterest.travel,
        title: 'Travel & Destinations',
        description:
            'Destination outlooks, rainfall probabilities & automated packing lists.',
        metric: 'London: 18°C Rain 70%',
        route: '/explore/travel',
      ),
      _ModuleItem(
        interest: UserInterest.family,
        title: 'Family & School',
        description:
            'School commute weather, morning conditions & child rain alerts.',
        metric: 'Clear Morning Routes',
        route: '/explore/family',
      ),
      _ModuleItem(
        interest: UserInterest.agriculture,
        title: 'Agriculture & Farm',
        description:
            'Soil moisture, frost danger alerts, crop cycles & optimal sowing timing.',
        metric: 'Soil: 42% • Low Frost',
        route: '/explore/agriculture',
      ),
      _ModuleItem(
        interest: UserInterest.commute,
        title: 'Commute & Highway',
        description:
            'Route weather, highway fog warnings, visibility & traffic indicators.',
        metric: 'Moderate Traffic • 6km Vis',
        route: '/explore/commute',
      ),
      _ModuleItem(
        interest: UserInterest.eventPlanner,
        title: 'Event Planner',
        description:
            'Outdoor wedding & event suitability, comfort index, multi-day rain risk.',
        metric: 'Outdoor: Suitable',
        route: '/explore/event-planner',
      ),
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Explore Modules'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            Text(
              '8 Specialized Weather Dashboards',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hyper-targeted insights built for diverse routines and lifestyles.',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = modules[index];
                final accent = item.interest.accentColor;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadius.brXl,
                    onTap: () => context.push(item.route),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceCard
                            : AppColors.lightSurfaceCard,
                        borderRadius: AppRadius.brXl,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.18),
                              borderRadius: AppRadius.brMd,
                            ),
                            child: Icon(
                              item.interest.iconData,
                              size: 26,
                              color: accent,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item.title,
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
                                    const SizedBox(width: 6),
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: accent.withOpacity(0.15),
                                          borderRadius: AppRadius.brPill,
                                        ),
                                        child: Text(
                                          item.metric,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              AppTypography.labelSmall.copyWith(
                                            color: accent,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.textDarkMuted
                                        : AppColors.textLightMuted,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.textDarkMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ModuleItem {
  final UserInterest interest;
  final String title;
  final String description;
  final String metric;
  final String route;

  const _ModuleItem({
    required this.interest,
    required this.title,
    required this.description,
    required this.metric,
    required this.route,
  });
}
