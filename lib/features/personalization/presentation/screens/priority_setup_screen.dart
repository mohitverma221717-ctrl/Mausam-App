import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/personalization_models.dart';
import '../providers/personalization_provider.dart';

class PrioritySetupScreen extends ConsumerWidget {
  const PrioritySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(personalizationProvider);
    final notifier = ref.read(personalizationProvider.notifier);

    // Filter rules to only show user-selected interests
    final userRules = state.priorityRules
        .where((r) => state.selectedInterests.contains(r.interest))
        .toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/personalization/interests');
        }
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          title: const Text('Priority Setup'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/personalization/interests');
              }
            },
          ),
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set Your Priorities',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Drag and reorder what matters most. Items at the top appear first on your home weather dashboard.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Reorderable List
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: userRules.length,
                  onReorder: (oldIndex, newIndex) {
                    notifier.reorderPriorityRules(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final rule = userRules[index];
                    final interest = rule.interest;
                    final accent = interest.accentColor;

                    return Padding(
                      key: ValueKey(interest.name),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: isDark
                            ? AppColors.darkSurfaceCard
                            : AppColors.lightSurfaceCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.brLg,
                          side: BorderSide(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: AppTypography.labelSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentCyan,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.18),
                                borderRadius: AppRadius.brSm,
                              ),
                              child: Icon(interest.iconData,
                                  size: 20, color: accent),
                            ),
                          ],
                        ),
                        title: Text(
                          interest.displayName,
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        subtitle: Text(
                          interest.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkMuted
                                : AppColors.textLightMuted,
                            fontSize: 11,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.drag_handle_rounded,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ),
                  );
                },
                ),
              ),

              const SizedBox(height: 16),

              // Save & Continue Button
              MausamButton(
                text: 'Save & Continue to Home',
                width: double.infinity,
                onPressed: () async {
                  await ref.read(authProvider.notifier).completeOnboarding();
                  if (context.mounted) {
                    context.go('/home');
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ),
  );
}
}
