import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/earthquake/domain/models/earthquake_event.dart';
import 'package:mausam_app/features/advanced/earthquake/domain/repositories/earthquake_repository.dart';

class EarthquakeScreen extends ConsumerWidget {
  const EarthquakeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earthquakesAsync = ref.watch(recentEarthquakesProvider);

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
          'Earthquake Monitor',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: earthquakesAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const AdvancedEmptyState(
              title: 'No Recent Seismic Activity',
              message:
                  'No significant seismic activity detected in monitored regions recently.',
              icon: Icons.vibration_rounded,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(recentEarthquakesProvider);
            },
            color: AppColors.cyanAccent,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Disclaimer Banner (Mandatory Requirement: NEVER claim prediction)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.amber.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Colors.amber, size: 22),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Notice: Science cannot predict earthquakes. This screen displays verified historical & detected seismic events only.',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recent Detected Seismic Events',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...events.map((event) => _buildEarthquakeCard(event)),
                const SizedBox(height: 16),
                const DataSourceBadge(
                  source: 'USGS & National Centre for Seismology',
                  lastUpdated: 'Live Seismic Feed',
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const AdvancedLoadingState(
          message: 'Loading global seismic telemetry data...',
        ),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.refresh(recentEarthquakesProvider),
        ),
      ),
    );
  }

  Widget _buildEarthquakeCard(EarthquakeEvent event) {
    final timeStr = DateFormat('MMM d, h:mm a').format(event.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: event.magnitudeColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: event.magnitudeColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.magnitude.toStringAsFixed(1),
                      style: TextStyle(
                        color: event.magnitudeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'MAG',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.place,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${event.intensityLabel} • Depth: ${event.depthKm} km',
                          style: TextStyle(
                            color: event.magnitudeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.near_me_outlined,
                      size: 14, color: AppColors.cyanAccent),
                  const SizedBox(width: 4),
                  Text(
                    '~${event.distanceKm.toInt()} km from you',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                timeStr,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
