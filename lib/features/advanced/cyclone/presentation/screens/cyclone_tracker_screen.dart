import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/cyclone/domain/repositories/cyclone_repository.dart';

class CycloneTrackerScreen extends ConsumerWidget {
  const CycloneTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cyclonesAsync = ref.watch(activeCyclonesProvider);

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
          'Cyclone Tracker',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cyclonesAsync.when(
        data: (cyclones) {
          if (cyclones.isEmpty) {
            return const AdvancedEmptyState(
              title: 'No Active Cyclones',
              message:
                  'No tropical cyclones or severe depressions currently active in monitored ocean basins.',
              icon: Icons.cyclone_rounded,
            );
          }

          final cyclone = cyclones.first;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(activeCyclonesProvider);
            },
            color: AppColors.cyanAccent,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Cyclone Main Status Header Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cyclone.categoryColor.withOpacity(0.3),
                        AppColors.darkBackgroundSecondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: cyclone.categoryColor.withOpacity(0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: cyclone.categoryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: cyclone.categoryColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cyclone,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    cyclone.category.toUpperCase(),
                                    style: TextStyle(
                                      color: cyclone.categoryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            cyclone.oceanBasin,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cyclone.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              'Wind Speed',
                              '${cyclone.currentPosition.windSpeedKmh.toInt()} km/h',
                              Icons.air_rounded,
                              AppColors.cyanAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMetricTile(
                              'Pressure',
                              '${cyclone.currentPosition.pressureHpa.toInt()} hPa',
                              Icons.compress_rounded,
                              Colors.orangeAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              'Movement',
                              '${cyclone.movementDirection} @ ${cyclone.movementSpeedKmh} km/h',
                              Icons.explore_rounded,
                              Colors.purpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Landfall Forecast Card
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
                      const Row(
                        children: [
                          Icon(Icons.pin_drop_rounded,
                              color: Colors.redAccent, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Expected Landfall Prediction',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Location: ${cyclone.expectedLandfallLocation}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Estimated Time: ${cyclone.expectedLandfallTime}',
                        style: const TextStyle(
                          color: AppColors.cyanAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Note: Forecast trajectory is subject to meteorological revisions as satellite updates arrive.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Track & Forecast Path Timeline
                const Text(
                  'Observed & Forecast Track Timeline',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...cyclone.observedTrack.map(
                  (pt) => _buildTrackTile(
                    'Observed Path',
                    '${pt.latitude.toStringAsFixed(1)}°N, ${pt.longitude.toStringAsFixed(1)}°E',
                    '${pt.windSpeedKmh.toInt()} km/h wind',
                    false,
                  ),
                ),
                ...cyclone.forecastPath.map(
                  (fp) => _buildTrackTile(
                    'Forecast Track (${fp.intensityCategory})',
                    '${fp.latitude.toStringAsFixed(1)}°N, ${fp.longitude.toStringAsFixed(1)}°E',
                    'Est. ${fp.expectedWindSpeedKmh.toInt()} km/h wind',
                    true,
                  ),
                ),
                const SizedBox(height: 20),

                // Affected Regions List
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
                        'High Threat Coastal Regions',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...cyclone.affectedRegions.map(
                        (region) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.orangeAccent, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  region,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DataSourceBadge(
                  source: cyclone.source,
                  lastUpdated: 'Live RSMC Bulletin',
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const AdvancedLoadingState(
          message: 'Tracking active cyclones and tropical storms...',
        ),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.invalidate(activeCyclonesProvider),
        ),
      ),
    );
  }

  Widget _buildMetricTile(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      const TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
                Text(
                  value,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTile(
      String title, String coords, String detail, bool isForecast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundSecondary.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isForecast
              ? Colors.cyan.withOpacity(0.4)
              : Colors.blue.withOpacity(0.4),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isForecast ? Icons.timeline_rounded : Icons.my_location_rounded,
            size: 16,
            color: isForecast ? AppColors.cyanAccent : Colors.blueAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: true,
                  style: TextStyle(
                    color: isForecast
                        ? AppColors.cyanAccent
                        : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  coords,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: Text(
              detail,
              textAlign: TextAlign.end,
              softWrap: true,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

