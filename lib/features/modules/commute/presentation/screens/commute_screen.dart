import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../presentation/providers/module_providers.dart';

class CommuteScreen extends ConsumerWidget {
  const CommuteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commuteAsync = ref.watch(commuteDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Commute & Highway Weather'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: commuteAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading commute data: $err')),
        data: (commute) {
          final active = commute.activeRoute;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active Route Hero Card
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_car_rounded,
                              color: AppColors.accentCyan),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              active.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFFFB300).withOpacity(0.18),
                                borderRadius: AppRadius.brPill,
                              ),
                              child: Text(
                                active.conditionSummary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFFFFB300),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${active.origin} ➔ ${active.destination}',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textDarkMuted
                              : AppColors.textLightMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 14),

                      // Metrics Row
                      Row(
                        children: [
                          Expanded(
                            child: _CommuteStat(
                              title: 'Traffic',
                              value: active.trafficStatus,
                              icon: Icons.traffic_rounded,
                              color: const Color(0xFFFFB300),
                            ),
                          ),
                          Expanded(
                            child: _CommuteStat(
                              title: 'Rain',
                              value: '${active.rainChance}%',
                              icon: Icons.water_drop_rounded,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Expanded(
                            child: _CommuteStat(
                              title: 'Visibility',
                              value: '${active.visibilityKm.toInt()} km',
                              icon: Icons.visibility_rounded,
                              color: AppColors.statusSuccess,
                            ),
                          ),
                          Expanded(
                            child: _CommuteStat(
                              title: 'Wind',
                              value: '${active.windSpeed.toInt()} km/h',
                              icon: Icons.air_rounded,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Overall Commute Advisory
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.lightBackgroundSecondary,
                    borderRadius: AppRadius.brLg,
                    border: Border.all(
                        color: isDark
                            ? AppColors.darkBorderSubtle
                            : AppColors.lightBorderSubtle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.accentCyan, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          commute.overallAdvice,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Saved Routes
                Text(
                  'Saved Routes & Corridors',
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
                  itemCount: commute.savedRoutes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final r = commute.savedRoutes[index];

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
                                : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.textDarkPrimary
                                        : AppColors.textLightPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${r.origin} ➔ ${r.destination}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.18),
                                borderRadius: AppRadius.brPill,
                              ),
                              child: Text(
                                r.conditionSummary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.accentCyan,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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

class _CommuteStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _CommuteStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textLightPrimary,
            ),
          ),
        ),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
