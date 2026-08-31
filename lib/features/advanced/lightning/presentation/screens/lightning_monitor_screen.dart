import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/lightning/domain/repositories/lightning_repository.dart';

class LightningMonitorScreen extends ConsumerWidget {
  const LightningMonitorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightningAsync = ref.watch(lightningActivityProvider);

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
          'Lightning Monitor',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: lightningAsync.when(
        data: (activity) {
          final timeStr =
              DateFormat('h:mm:ss a').format(activity.lastStrikeTimestamp);

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(lightningActivityProvider);
            },
            color: AppColors.cyanAccent,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Status Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        activity.statusColor.withOpacity(0.3),
                        AppColors.darkBackgroundSecondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: activity.statusColor.withOpacity(0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flash_on_rounded,
                                  color: activity.statusColor, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                '${activity.densityLevel.toUpperCase()} ACTIVITY',
                                style: TextStyle(
                                  color: activity.statusColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'LIVE RADAR',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nearest strike detected ${activity.nearestStrikeKm} km away',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Last detected strike: $timeStr',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Metrics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricBox(
                        'Strikes (Past Hour)',
                        '${activity.strikeCountLastHour}',
                        Icons.electric_bolt_rounded,
                        AppColors.cyanAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricBox(
                        'Active Storm Cells',
                        '${activity.activeStormCells}',
                        Icons.storm_rounded,
                        Colors.purpleAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Safety Guidance Box
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
                      Row(
                        children: const [
                          Icon(Icons.shield_rounded,
                              color: AppColors.cyanAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Lightning Safety Protocol',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• When thunder roars, go indoors. Stay in a substantial building or hard-topped metal vehicle.',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.4),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '• Avoid corded phones, electrical equipment, plumbing fixtures, and concrete walls/floors.',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DataSourceBadge(
                  source: activity.source,
                  lastUpdated: 'Real-time Pulse Feed',
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const AdvancedLoadingState(
          message: 'Connecting to atmospheric lightning telemetry sensors...',
        ),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.refresh(lightningActivityProvider),
        ),
      ),
    );
  }

  Widget _buildMetricBox(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
