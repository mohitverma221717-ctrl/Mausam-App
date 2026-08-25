import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/settings_provider.dart';
import '../../domain/models/app_settings.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final languages = [
      {'code': AppLanguage.english, 'name': 'English', 'native': 'English'},
      {'code': AppLanguage.hindi, 'name': 'Hindi', 'native': 'हिन्दी (Hindi)'},
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Language / भाषा'),
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
            children: languages.map((lang) {
              final isSelected = settings.language == lang['code'];

              return ListTile(
                onTap: () => notifier.setLanguage(lang['code'] as AppLanguage),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  lang['native'] as String,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                subtitle: Text(
                  lang['name'] as String,
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
