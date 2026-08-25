import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/severity_badge.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../providers/alerts_provider.dart';
import '../../domain/models/weather_alert.dart';

enum AlertCategoryFilter {
  all('All'),
  severe('Severe'),
  rain('Rain & Storm'),
  heat('Heat Wave'),
  fog('Fog & Cold'),
  history('Past History');

  final String label;
  const AlertCategoryFilter(this.label);
}

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  AlertCategoryFilter _selectedFilter = AlertCategoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertsState = ref.watch(alertsProvider);
    final alertsNotifier = ref.read(alertsProvider.notifier);
    final location = ref.watch(locationProvider).selectedLocation;

    // Filter alerts list based on active tab
    List<WeatherAlert> displayAlerts;
    if (_selectedFilter == AlertCategoryFilter.history) {
      displayAlerts = alertsState.alertHistory;
    } else {
      displayAlerts = alertsState.activeAlerts.where((a) {
        switch (_selectedFilter) {
          case AlertCategoryFilter.all:
            return true;
          case AlertCategoryFilter.severe:
            return a.severity == AlertSeverity.high || a.severity == AlertSeverity.extreme;
          case AlertCategoryFilter.rain:
            return a.type.toLowerCase().contains('rain') ||
                a.type.toLowerCase().contains('thunder') ||
                a.type.toLowerCase().contains('storm');
          case AlertCategoryFilter.heat:
            return a.type.toLowerCase().contains('heat') ||
                a.type.toLowerCase().contains('thermal');
          case AlertCategoryFilter.fog:
            return a.type.toLowerCase().contains('fog') ||
                a.type.toLowerCase().contains('cold');
          case AlertCategoryFilter.history:
            return true;
        }
      }).toList();
    }

    final hasSevereAlert = alertsState.activeAlerts
        .any((a) => a.severity == AlertSeverity.high || a.severity == AlertSeverity.extreme);
    final severeAlert = hasSevereAlert
        ? alertsState.activeAlerts.firstWhere(
            (a) => a.severity == AlertSeverity.high || a.severity == AlertSeverity.extreme)
        : null;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weather Alerts'),
            Text(
              '${location.name}, ${location.state}',
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 24),
                if (alertsState.unreadNotificationsCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.statusDanger,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'Notification Hub',
            onPressed: () => context.push('/alerts/notifications'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => alertsNotifier.loadAlerts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Dynamic Overall Threat / Status Banner
                if (alertsState.activeAlerts.isEmpty)
                  _AllClearStatusBanner(isDark: isDark, locationName: location.name)
                else if (hasSevereAlert && severeAlert != null)
                  _SevereEmergencyBanner(
                    isDark: isDark,
                    alert: severeAlert,
                    onTap: () {
                      alertsNotifier.markAlertAsRead(severeAlert.id);
                      context.push('/alerts/detail/${severeAlert.id}');
                    },
                  )
                else
                  _ModerateStatusBanner(
                    isDark: isDark,
                    count: alertsState.activeAlerts.length,
                    locationName: location.name,
                  ),
                const SizedBox(height: 16),

                // 2. Interactive Category Filter Bar
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AlertCategoryFilter.values.map((filter) {
                      final isSelected = filter == _selectedFilter;
                      int badgeCount = 0;
                      if (filter == AlertCategoryFilter.all) {
                        badgeCount = alertsState.activeAlerts.length;
                      } else if (filter == AlertCategoryFilter.severe) {
                        badgeCount = alertsState.activeAlerts
                            .where((a) =>
                                a.severity == AlertSeverity.high ||
                                a.severity == AlertSeverity.extreme)
                            .length;
                      } else if (filter == AlertCategoryFilter.history) {
                        badgeCount = alertsState.alertHistory.length;
                      }

                      final labelText = badgeCount > 0
                          ? '${filter.label} ($badgeCount)'
                          : filter.label;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: AppRadius.brPill,
                            onTap: () => setState(() => _selectedFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryBlue
                                    : (isDark
                                        ? AppColors.darkSurfaceCard
                                        : AppColors.lightSurfaceCard),
                                borderRadius: AppRadius.brPill,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                              ),
                              child: Text(
                                labelText,
                                style: AppTypography.labelSmall.copyWith(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white : AppColors.textLightPrimary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Section Title & Live Counter
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedFilter == AlertCategoryFilter.history
                            ? 'Past Alert History'
                            : 'Active Warnings & Safety Directives',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withOpacity(0.15),
                        borderRadius: AppRadius.brPill,
                      ),
                      child: Text(
                        '${displayAlerts.length} ${displayAlerts.length == 1 ? 'Alert' : 'Alerts'}',
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. Alert Cards List
                if (displayAlerts.isEmpty)
                  _NoAlertsMatchingFilter(isDark: isDark, filterLabel: _selectedFilter.label)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayAlerts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final alert = displayAlerts[index];
                      final isExpired = alert.endTime.isBefore(DateTime.now());

                      return _AlertProductionCard(
                        alert: alert,
                        isDark: isDark,
                        isExpired: isExpired,
                        onTap: () {
                          alertsNotifier.markAlertAsRead(alert.id);
                          context.push('/alerts/detail/${alert.id}');
                        },
                      );
                    },
                  ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SevereEmergencyBanner extends StatelessWidget {
  final bool isDark;
  final WeatherAlert alert;
  final VoidCallback onTap;

  const _SevereEmergencyBanner({
    required this.isDark,
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.statusDanger.withOpacity(isDark ? 0.18 : 0.12),
        borderRadius: AppRadius.brXl,
        border: Border.all(color: AppColors.statusDanger, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.statusDanger.withOpacity(0.2),
            blurRadius: 16,
            spreadRadius: 1,
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
                decoration: const BoxDecoration(
                  color: AppColors.statusDanger,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SEVERE WEATHER WARNING ACTIVE',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.statusDanger,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alert.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.textLightPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.statusDanger,
                  borderRadius: AppRadius.brPill,
                ),
                child: const Text(
                  'CRITICAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            alert.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            borderRadius: AppRadius.brMd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.statusDanger,
                borderRadius: AppRadius.brMd,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'View Safety Advisory & Protocol',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModerateStatusBanner extends StatelessWidget {
  final bool isDark;
  final int count;
  final String locationName;

  const _ModerateStatusBanner({
    required this.isDark,
    required this.count,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.statusWarning.withOpacity(isDark ? 0.14 : 0.1),
        borderRadius: AppRadius.brLg,
        border: Border.all(color: AppColors.statusWarning.withOpacity(0.7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.statusWarning, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count Active Weather ${count == 1 ? 'Advisory' : 'Advisories'} in $locationName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Moderate atmospheric conditions. Review safety precautions below.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllClearStatusBanner extends StatelessWidget {
  final bool isDark;
  final String locationName;

  const _AllClearStatusBanner({
    required this.isDark,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.statusSuccess.withOpacity(isDark ? 0.14 : 0.1),
        borderRadius: AppRadius.brLg,
        border: Border.all(color: AppColors.statusSuccess.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.statusSuccess, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Active Weather Warnings',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Atmospheric conditions are normal and safe for $locationName.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertProductionCard extends StatelessWidget {
  final WeatherAlert alert;
  final bool isDark;
  final bool isExpired;
  final VoidCallback onTap;

  const _AlertProductionCard({
    required this.alert,
    required this.isDark,
    required this.isExpired,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.brXl,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
            borderRadius: AppRadius.brXl,
            border: Border.all(
              color: isExpired
                  ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                  : alert.severity.color.withOpacity(0.55),
              width: 1.5,
            ),
            boxShadow: [
              if (!isExpired)
                BoxShadow(
                  color: alert.severity.color.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Title + Severity + Active Status Chip
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isExpired ? Icons.history_rounded : Icons.warning_amber_rounded,
                    color: isExpired ? AppColors.textDarkMuted : alert.severity.color,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SeverityBadge(severity: alert.severity),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                          : AppColors.statusSuccess.withOpacity(0.18),
                      borderRadius: AppRadius.brPill,
                    ),
                    child: Text(
                      isExpired ? 'EXPIRED' : 'ACTIVE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: isExpired ? AppColors.textDarkMuted : AppColors.statusSuccess,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location & Time Window Metadata (Clean Bounded Rows)
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.accentCyan),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alert.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 13, color: AppColors.textDarkMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alert.timeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: alert.severity.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Alert Description
              Text(
                alert.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 10),

              // Safety Directive Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightBackgroundSecondary,
                  borderRadius: AppRadius.brSm,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, size: 16, color: AppColors.accentCyan),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'What to do: ${alert.advisory}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Footer Provenance & Detail Trigger Link
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Source: ${alert.source}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Full Details ➔',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentCyan,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoAlertsMatchingFilter extends StatelessWidget {
  final bool isDark;
  final String filterLabel;

  const _NoAlertsMatchingFilter({
    required this.isDark,
    required this.filterLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
        borderRadius: AppRadius.brXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded, size: 44, color: AppColors.statusSuccess),
            const SizedBox(height: 12),
            Text(
              'No $filterLabel Alerts',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No active weather warnings match this selected filter.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
