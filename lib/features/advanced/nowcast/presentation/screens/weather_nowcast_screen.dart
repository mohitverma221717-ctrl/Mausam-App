import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/nowcast/domain/repositories/nowcast_repository.dart';

class WeatherNowcastScreen extends ConsumerWidget {
  const WeatherNowcastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowcastAsync = ref.watch(nowcastDataProvider);

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
          'Short-Term Weather Nowcast',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: nowcastAsync.when(
        data: (nowcast) {
          if (nowcast == null) {
            return const AdvancedEmptyState(
              title: 'Nowcast Unavailable',
              message:
                  'Nowcast data unavailable for your current location at this moment.',
              icon: Icons.grain_rounded,
            );
          }

          final timeStr = DateFormat('h:mm a').format(nowcast.lastUpdated);

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(nowcastDataProvider);
            },
            color: AppColors.cyanAccent,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Highlight Banner Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.umbrella_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'PRECIPITATION NOWCAST (0–60 MIN)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        nowcast.rainWindowText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildMiniBadge(
                              'Rain Prob: ${nowcast.rainProbability}%'),
                          const SizedBox(width: 8),
                          _buildMiniBadge('Trend: ${nowcast.shortTermTrend}'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 60-Minute Precipitation Timeline
                const Text(
                  'Next 60-Minute Rain Timeline',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...nowcast.timeline.map(
                  (step) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkBackgroundSecondary,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.glassBorder.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 65,
                              child: Text(
                                step.minutesOffset,
                                style: const TextStyle(
                                  color: AppColors.cyanAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              step.status,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${step.rainAmountMm} mm/h',
                          style: TextStyle(
                            color: step.rainAmountMm > 0
                                ? Colors.cyan
                                : AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DataSourceBadge(
                  source: nowcast.source,
                  lastUpdated: 'Updated at $timeStr',
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const AdvancedLoadingState(
          message: 'Running high-resolution short-term nowcast simulation...',
        ),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.refresh(nowcastDataProvider),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
