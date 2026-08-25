import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../presentation/providers/module_providers.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyAsync = ref.watch(familyDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Family & School Commute'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: familyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading family data: $err')),
        data: (family) {
          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // School Commute Status Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    borderRadius: AppRadius.brXl,
                    border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF4081).withOpacity(0.18),
                        ),
                        child: const Icon(
                          Icons.family_restroom_rounded,
                          color: Color(0xFFFF4081),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Morning Family Briefing',
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              family.schoolCommuteSummary,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.statusSuccess,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Family Members & Route Weather',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: family.members.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final member = family.members[index];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceCard
                            : AppColors.lightSurfaceCard,
                        borderRadius: AppRadius.brLg,
                        border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue
                                          .withOpacity(0.15),
                                      borderRadius: AppRadius.brSm,
                                    ),
                                    child: Icon(
                                      member.category == 'School'
                                          ? Icons.school_rounded
                                          : (member.category == 'Work'
                                              ? Icons.business_center_rounded
                                              : Icons.home_rounded),
                                      color: AppColors.accentCyan,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.name,
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? AppColors.textDarkPrimary
                                              : AppColors.textLightPrimary,
                                        ),
                                      ),
                                      Text(
                                        member.placeName,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark
                                              ? AppColors.textDarkMuted
                                              : AppColors.textLightMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                '${member.currentTemp.toInt()}°C',
                                style: AppTypography.titleLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textDarkPrimary
                                      : AppColors.textLightPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.water_drop_rounded,
                                      size: 12, color: AppColors.primaryBlue),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${member.rainChance}% Rain Chance',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.textDarkSecondary
                                          : AppColors.textLightSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.statusSuccess.withOpacity(0.18),
                                  borderRadius: AppRadius.brPill,
                                ),
                                child: Text(
                                  member.morningStatus,
                                  style: const TextStyle(
                                    color: AppColors.statusSuccess,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (member.alertNotice != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              member.alertNotice!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.statusWarning,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
