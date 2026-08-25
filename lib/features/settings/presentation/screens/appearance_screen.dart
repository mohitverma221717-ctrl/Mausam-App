import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/settings_provider.dart';
import '../../domain/models/app_settings.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final themes = [
      {
        'mode': AppThemeMode.dark,
        'title': 'Dark Theme (Default)',
        'sub': 'Deep navy background with cyan & blue accents',
        'icon': Icons.dark_mode_rounded
      },
      {
        'mode': AppThemeMode.light,
        'title': 'Light Theme',
        'sub': 'Crisp clean white and light slate surfaces',
        'icon': Icons.light_mode_rounded
      },
      {
        'mode': AppThemeMode.system,
        'title': 'System Default',
        'sub': 'Matches device operating system appearance',
        'icon': Icons.settings_brightness_rounded
      },
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Appearance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
            borderRadius: AppRadius.brXl,
            border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: themes.map((t) {
              final isSelected = settings.themeMode == t['mode'];

              return ListTile(
                onTap: () => notifier.setThemeMode(t['mode'] as AppThemeMode),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.18),
                    borderRadius: AppRadius.brSm,
                  ),
                  child:
                      Icon(t['icon'] as IconData, color: AppColors.accentCyan),
                ),
                title: Text(
                  t['title'] as String,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                subtitle: Text(
                  t['sub'] as String,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textDarkMuted
                        : AppColors.textLightMuted,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.accentCyan)
                    : null,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
