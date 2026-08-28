import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/severity_badge.dart';
import '../providers/alerts_provider.dart';
import '../../domain/models/weather_alert.dart';

class AlertDetailScreen extends ConsumerWidget {
  final String alertId;

  const AlertDetailScreen({
    super.key,
    required this.alertId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsState = ref.watch(alertsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final alert = alertsState.activeAlerts.firstWhere(
      (a) => a.id == alertId,
      orElse: () => alertsState.alertHistory.firstWhere(
        (a) => a.id == alertId,
        orElse: () => WeatherAlert(
          id: 'alert-default',
          title: 'Heavy Rain Alert',
          type: 'Rain & Thunder',
          severity: AlertSeverity.high,
          location: 'Lucknow & nearby areas',
          timeRange: 'Expected 8:00 PM – 11:00 PM',
          description:
              'Intense rainfall accompanied by gusty winds up to 45 km/h.',
          advisory:
              'Avoid waterlogged underpasses. Secure loose outdoor objects.',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 3)),
          source: 'India Meteorological Department (IMD)',
        ),
      ),
    );

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Alert Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: alert.severity.color.withOpacity(0.18),
                borderRadius: AppRadius.brXl,
                border:
                    Border.all(color: alert.severity.color.withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SeverityBadge(severity: alert.severity),
                      Text(
                        alert.type,
                        style: AppTypography.labelMedium.copyWith(
                          color: alert.severity.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    alert.title,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textLightPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert.location,
                    style: AppTypography.titleMedium.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.timeRange,
                    style: AppTypography.labelSmall.copyWith(
                      color: alert.severity.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text('Situation Overview', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              alert.description,
              style: AppTypography.bodyMedium.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),

            // Recommended Protective Actions
            Text('Recommended Safety Actions', style: AppTypography.titleLarge),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard
                    : AppColors.lightSurfaceCard,
                borderRadius: AppRadius.brLg,
                border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  _SafetyActionRow(
                    icon: Icons.shield_rounded,
                    text: alert.advisory,
                  ),
                  const SizedBox(height: 10),
                  const _SafetyActionRow(
                    icon: Icons.electrical_services_rounded,
                    text:
                        'Unplug sensitive electronics during lightning storms.',
                  ),
                  const SizedBox(height: 10),
                  const _SafetyActionRow(
                    icon: Icons.drive_eta_rounded,
                    text:
                        'Avoid driving through flooded underpasses and culverts.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Issuing Authority
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.lightBackgroundSecondary,
                borderRadius: AppRadius.brMd,
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded,
                      color: AppColors.accentCyan),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Issuing Agency', style: AppTypography.labelSmall),
                        Text(
                          alert.source,
                          style: AppTypography.labelMedium
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyActionRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SafetyActionRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.accentCyan),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: AppTypography.bodySmall),
        ),
      ],
    );
  }
}
