import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../settings/domain/models/app_settings.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurfaceCard
              : AppColors.lightSurface,
          title: const Text('Confirm Logout'),
          content: const Text(
              'Are you sure you want to log out of your MAUSAM account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusDanger),
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/get-started');
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final settings = ref.watch(settingsProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard
                    : AppColors.lightSurfaceCard,
                borderRadius: AppRadius.brXl,
                border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.accentCyan],
                      ),
                      border: Border.all(color: AppColors.accentCyan, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        user != null && user.name.isNotEmpty
                            ? user.name.substring(0, 1)
                            : 'A',
                        style: AppTypography.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Aarav Sharma',
                          style: AppTypography.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'aarav@gmail.com',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkMuted
                                : AppColors.textLightMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: AppColors.accentCyan),
                    onPressed: () => context.push('/profile/edit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Preference Settings Group
            Text(
              'Personalization & Places',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 10),

            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.auto_awesome_rounded,
                  title: 'My Interests',
                  subtitle: '${user?.interests.length ?? 6} active categories',
                  onTap: () => context.push('/personalization/interests'),
                ),
                _SettingsTile(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'Saved Locations',
                  subtitle: 'Home, College, Work, Travel places',
                  onTap: () => context.push('/locations/manage'),
                ),
                _SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notification Center',
                  subtitle: 'Recent alerts & briefing updates',
                  onTap: () => context.push('/alerts/notifications'),
                ),
                _SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notification Settings',
                  subtitle: 'Weather & severe rain alerts',
                  onTap: () => context.push('/profile/notifications'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Preferences Group
            Text(
              'App Preferences',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 10),

            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.straighten_rounded,
                  title: 'Units & Formats',
                  subtitle:
                      '${settings.temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F'} • ${settings.windUnit.name.toUpperCase()}',
                  onTap: () => context.push('/profile/units'),
                ),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: settings.language == AppLanguage.hindi
                      ? 'हिन्दी (Hindi)'
                      : 'English',
                  onTap: () => context.push('/profile/language'),
                ),
                _SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Appearance Theme',
                  subtitle: settings.themeMode == AppThemeMode.dark
                      ? 'Dark Theme'
                      : (settings.themeMode == AppThemeMode.light
                          ? 'Light Theme'
                          : 'System Default'),
                  onTap: () => context.push('/profile/appearance'),
                ),
                _SettingsTile(
                  icon: Icons.screen_lock_portrait_rounded,
                  title: 'Always-On Display (AOD)',
                  subtitle: 'Ambient clock & weather glance on standby',
                  onTap: () => context.push('/profile/aod'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Help & About
            Text(
              'Support & Legal',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 10),

            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Feedback',
                  subtitle: 'FAQs, report bug, contact support',
                  onTap: () => context.push('/profile/help'),
                ),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About MAUSAM',
                  subtitle: 'Version 1.0.0 • IMD MoES partner',
                  onTap: () => context.push('/profile/about'),
                ),
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  subtitle: 'Sign out of this device',
                  iconColor: AppColors.statusDanger,
                  textColor: AppColors.statusDanger,
                  onTap: () => _showLogoutDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brXl,
        side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primaryBlue).withOpacity(0.15),
          borderRadius: AppRadius.brSm,
        ),
        child: Icon(icon, size: 20, color: iconColor ?? AppColors.accentCyan),
      ),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: textColor ??
              (isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
          fontSize: 11,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.textDarkMuted,
      ),
    );
  }
}
