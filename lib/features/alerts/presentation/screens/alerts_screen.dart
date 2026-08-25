import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/severity_badge.dart';
import '../providers/alerts_provider.dart';
import '../../domain/models/weather_alert.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertsState = ref.watch(alertsProvider);
    final alertsNotifier = ref.read(alertsProvider.notifier);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Weather Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notification Hub',
            onPressed: () => context.push('/alerts/notifications'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Severity Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All (${alertsState.activeAlerts.length})',
                      isSelected: alertsState.filterSeverity == null,
                      onTap: () => alertsNotifier.setFilterSeverity(null),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'High',
                      color: AppColors.statusDanger,
                      isSelected:
                          alertsState.filterSeverity == AlertSeverity.high,
                      onTap: () =>
                          alertsNotifier.setFilterSeverity(AlertSeverity.high),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Moderate',
                      color: AppColors.statusWarning,
                      isSelected:
                          alertsState.filterSeverity == AlertSeverity.moderate,
                      onTap: () => alertsNotifier
                          .setFilterSeverity(AlertSeverity.moderate),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Low',
                      color: AppColors.statusSuccess,
                      isSelected:
                          alertsState.filterSeverity == AlertSeverity.low,
                      onTap: () =>
                          alertsNotifier.setFilterSeverity(AlertSeverity.low),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Active Warnings & Advisories',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 12),

              if (alertsState.filteredAlerts.isEmpty)
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    borderRadius: AppRadius.brXl,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            size: 48, color: AppColors.statusSuccess),
                        const SizedBox(height: 12),
                        Text(
                          "You're All Clear",
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No severe weather warnings active for this region.',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: alertsState.filteredAlerts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final alert = alertsState.filteredAlerts[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: AppRadius.brXl,
                        onTap: () {
                          alertsNotifier.markAlertAsRead(alert.id);
                          context.push('/alerts/detail/${alert.id}');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceCard
                                : AppColors.lightSurfaceCard,
                            borderRadius: AppRadius.brXl,
                            border: Border.all(
                              color: alert.severity.color.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning_amber_rounded,
                                      color: alert.severity.color,
                                      size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      alert.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          AppTypography.titleLarge.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.textDarkPrimary
                                            : AppColors.textLightPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SeverityBadge(severity: alert.severity),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${alert.location} • ${alert.timeRange}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: alert.severity.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                alert.description,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLightSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Source: ${alert.source}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: isDark
                                            ? AppColors.textDarkMuted
                                            : AppColors.textLightMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'View Details ➔',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.accentCyan,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = color ?? AppColors.primaryBlue;

    return InkWell(
      borderRadius: AppRadius.brPill,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark
                  ? AppColors.darkSurfaceCard
                  : AppColors.lightSurfaceCard),
          borderRadius: AppRadius.brPill,
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : AppColors.textLightPrimary),
          ),
        ),
      ),
    );
  }
}
