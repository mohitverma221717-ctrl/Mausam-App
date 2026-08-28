import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../domain/models/personalization_models.dart';
import '../providers/personalization_provider.dart';

class ChooseInterestsScreen extends ConsumerWidget {
  const ChooseInterestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(personalizationProvider);
    final notifier = ref.read(personalizationProvider.notifier);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Personalize MAUSAM'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What matters to you?',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select one or more categories to dynamically tailor your weather dashboard cards.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // 8 Category Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: UserInterest.values.length,
                  itemBuilder: (context, index) {
                    final interest = UserInterest.values[index];
                    final isSelected =
                        state.selectedInterests.contains(interest);
                    final accent = interest.accentColor;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: AppRadius.brLg,
                        onTap: () => notifier.toggleInterest(interest),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? accent.withOpacity(0.18)
                                    : accent.withOpacity(0.12))
                                : (isDark
                                    ? AppColors.darkSurfaceCard
                                    : AppColors.lightSurfaceCard),
                            borderRadius: AppRadius.brLg,
                            border: Border.all(
                              color: isSelected
                                  ? accent
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                              width: isSelected ? 2.0 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: accent.withOpacity(0.25),
                                      blurRadius: 14,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: accent.withOpacity(0.2),
                                      borderRadius: AppRadius.brSm,
                                    ),
                                    child: Icon(
                                      interest.iconData,
                                      color: accent,
                                      size: 22,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: accent,
                                      size: 22,
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    interest.displayName,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.textDarkPrimary
                                          : AppColors.textLightPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    interest.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.textDarkMuted
                                          : AppColors.textLightMuted,
                                      fontSize: 10,
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
              ),

              const SizedBox(height: 16),

              // Continue Button
              MausamButton(
                text: 'Continue (${state.selectedInterests.length} selected)',
                width: double.infinity,
                onPressed: () {
                  context.push('/personalization/priority');
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
