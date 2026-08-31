import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/disaster/domain/models/disaster_model.dart';
import 'package:mausam_app/features/advanced/disaster/domain/repositories/disaster_repository.dart';

class DisasterDetailScreen extends ConsumerWidget {
  final String disasterId;

  const DisasterDetailScreen({
    super.key,
    required this.disasterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disastersAsync = ref.watch(activeDisastersProvider);

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
          'Disaster Advisory Detail',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: disastersAsync.when(
          data: (alerts) {
            final alert = alerts.firstWhere(
              (a) => a.id == disasterId,
              orElse: () => alerts.first,
            );

            final timeStr =
                DateFormat('EEEE, MMM d, yyyy • h:mm a').format(alert.startTime);
            final updatedStr = DateFormat('h:mm a').format(alert.lastUpdated);

            return ListView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 36),
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackgroundSecondary,
                    borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: alert.severity.color.withOpacity(0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: alert.severity.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(alert.type.icon,
                              color: alert.severity.color, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert.type.displayName,
                                style: TextStyle(
                                  color: alert.severity.color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                alert.title,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
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
                      alert.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.location_on_rounded, 'Affected Region',
                        alert.affectedRegion),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        Icons.schedule_rounded, 'Start Time', timeStr),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // What to Do Section
              _buildSectionCard(
                title: 'What To Do',
                icon: Icons.check_circle_rounded,
                iconColor: const Color(0xFF10B981),
                items: alert.whatToDo,
              ),
              const SizedBox(height: 16),

              // What to Avoid Section
              _buildSectionCard(
                title: 'What To Avoid',
                icon: Icons.cancel_rounded,
                iconColor: const Color(0xFFEF4444),
                items: alert.whatToAvoid,
              ),
              const SizedBox(height: 16),

              // Preparedness Checklist
              _buildSectionCard(
                title: 'Preparedness Checklist',
                icon: Icons.playlist_add_check_circle_rounded,
                iconColor: AppColors.cyanAccent,
                items: alert.preparednessChecklist,
              ),
              const SizedBox(height: 20),

              DataSourceBadge(
                source: alert.source,
                lastUpdated: 'Updated at $updatedStr',
              ),
              const SizedBox(height: 24),
            ],
          );
        },
        loading: () => const AdvancedLoadingState(),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.refresh(activeDisastersProvider),
        ),
      ),
    ),
  );
}

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.cyanAccent),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
  }) {
    return Container(
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
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
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
