import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/settings_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Material(
            color:
                isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.brXl,
              side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              children: [
                _SwitchTile(
                  title: 'Weather Alerts',
                  subtitle:
                      'Real-time IMD weather warnings for current location',
                  value: settings.weatherAlerts,
                  onChanged: (val) =>
                      notifier.toggleNotification('weatherAlerts', val),
                ),
                _SwitchTile(
                  title: 'Rain Alerts',
                  subtitle:
                      'Pre-precipitation alerts 30 minutes before showers',
                  value: settings.rainAlerts,
                  onChanged: (val) =>
                      notifier.toggleNotification('rainAlerts', val),
                ),
                _SwitchTile(
                  title: 'Severe Weather Warnings',
                  subtitle: 'High & Extreme danger warnings with sound alerts',
                  value: settings.severeWeatherAlerts,
                  onChanged: (val) =>
                      notifier.toggleNotification('severeWeatherAlerts', val),
                ),
                _SwitchTile(
                  title: 'Daily Summary Briefing',
                  subtitle: 'Morning 7:00 AM day forecast and fitness window',
                  value: settings.dailySummary,
                  onChanged: (val) =>
                      notifier.toggleNotification('dailySummary', val),
                ),
                _SwitchTile(
                  title: 'Health & AQI Advisories',
                  subtitle:
                      'Alerts when air pollution reaches unhealthy thresholds',
                  value: settings.healthAlerts,
                  onChanged: (val) =>
                      notifier.toggleNotification('healthAlerts', val),
                ),
                _SwitchTile(
                  title: 'Travel & Trip Alerts',
                  subtitle: 'Severe alerts for saved travel destinations',
                  value: settings.travelAlerts,
                  onChanged: (val) =>
                      notifier.toggleNotification('travelAlerts', val),
                ),
                _SwitchTile(
                  title: 'Commute Weather',
                  subtitle:
                      'Visibility and traffic rain alerts before departure',
                  value: settings.commuteAlerts,
                  onChanged: (val) =>
                      notifier.toggleNotification('commuteAlerts', val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SwitchListTile(
      value: value,
      activeColor: AppColors.primaryBlue,
      activeTrackColor: AppColors.accentCyan.withOpacity(0.4),
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color:
              isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
          fontSize: 11,
        ),
      ),
    );
  }
}
