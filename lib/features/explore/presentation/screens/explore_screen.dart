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

    const domainModules = [
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

    const advancedIntelligenceModules = [
      _AdvancedModuleItem(
        title: 'Live Earth & Satellite',
        description:
            'Interactive global cloud layers, wind vectors & thermal radar.',
        icon: Icons.public_rounded,
        accentColor: Color(0xFF06B6D4),
        route: '/advanced/live-earth',
      ),
      _AdvancedModuleItem(
        title: 'Disaster Preparedness Hub',
        description:
            'Central emergency advisories, safety checklists & official warnings.',
        icon: Icons.health_and_safety_rounded,
        accentColor: Color(0xFFDC2626),
        route: '/advanced/disaster-hub',
      ),
      _AdvancedModuleItem(
        title: 'Cyclone Tracker',
        description:
            'Live tropical storm trajectory, wind intensity & landfall forecast.',
        icon: Icons.cyclone,
        accentColor: Color(0xFFEF4444),
        route: '/advanced/cyclone-tracker',
      ),
      _AdvancedModuleItem(
        title: 'Earthquake Monitor',
        description:
            'Seismic telemetry feed, epicenter map markers & depth metrics.',
        icon: Icons.vibration_rounded,
        accentColor: Color(0xFFF59E0B),
        route: '/advanced/earthquake-monitor',
      ),
      _AdvancedModuleItem(
        title: 'Lightning Radar',
        description:
            'Real-time strike density, cell velocity & proximity warnings.',
        icon: Icons.flash_on_rounded,
        accentColor: Color(0xFFA855F7),
        route: '/advanced/lightning-monitor',
      ),
      _AdvancedModuleItem(
        title: 'Air Quality Map & AQI',
        description: 'PM2.5 / PM10 concentration heatmap & health advisories.',
        icon: Icons.blur_on_rounded,
        accentColor: Color(0xFF10B981),
        route: '/advanced/air-quality-map',
      ),
      _AdvancedModuleItem(
        title: 'Weather Nowcast (0–60 Min)',
        description: 'Short-term precipitation windows & rapid trend updates.',
        icon: Icons.umbrella_rounded,
        accentColor: Color(0xFF0284C7),
        route: '/advanced/nowcast',
      ),
      _AdvancedModuleItem(
        title: 'Mausam Weather AI',
        description: 'Context-aware weather chat assistant for smart planning.',
        icon: Icons.smart_toy_rounded,
        accentColor: Color(0xFF3B82F6),
        route: '/advanced/ai-assistant',
      ),
      _AdvancedModuleItem(
        title: 'Smart Route Weather',
        description: 'Commute waypoint rain, fog hazard & highway visibility.',
        icon: Icons.alt_route_rounded,
        accentColor: Color(0xFF8B5CF6),
        route: '/advanced/smart-route',
      ),
      _AdvancedModuleItem(
        title: 'Configurable Home Widgets',
        description:
            'Customize and reorder home screen weather intelligence widgets.',
        icon: Icons.widgets_rounded,
        accentColor: Color(0xFFEC4899),
        route: '/advanced/widgets-setup',
      ),
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Explore Weather Intelligence'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // Section 1: 8 Specialized Weather Dashboards
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
            const SizedBox(height: 14),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: domainModules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = domainModules[index];
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
                                        style:
                                            AppTypography.titleLarge.copyWith(
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

            const SizedBox(height: 28),

            // Section 2: Advanced Intelligence & Earth Monitoring Grid
            Text(
              'Advanced Intelligence & Earth Monitoring',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Live telemetry, satellite layers, disaster monitoring & AI engines.',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
            ),
            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: advancedIntelligenceModules.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final item = advancedIntelligenceModules[index];
                return InkWell(
                  onTap: () => context.push(item.route),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceCard
                          : AppColors.lightSurfaceCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.accentColor.withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.accentColor.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon,
                              color: item.accentColor, size: 20),
                        ),
                        const Spacer(),
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textDarkPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textDarkMuted,
                            fontSize: 10,
                            height: 1.2,
                          ),
                        ),
                      ],
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

class _AdvancedModuleItem {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String route;

  const _AdvancedModuleItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.route,
  });
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
