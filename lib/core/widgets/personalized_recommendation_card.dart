import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../features/personalization/domain/models/personalization_models.dart';

class PersonalizedRecommendationCard extends StatelessWidget {
  final PersonalizedCardData data;

  const PersonalizedRecommendationCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = data.badgeColor ?? data.interest.accentColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                const BoxShadow(
                  color: Color(0x060F172A),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push(data.primaryActionRoute),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Rounded Icon Box
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? accent.withOpacity(0.18)
                          : (data.title.contains('Agriculture')
                              ? AppColors.greenTintBg
                              : AppColors.amberTintBg),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      data.icon,
                      size: 24,
                      color: isDark
                          ? accent
                          : (data.title.contains('Agriculture')
                              ? AppColors.greenTintText
                              : AppColors.amberTintText),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.serifTitle.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.interest.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkMuted
                                : AppColors.textLightMuted,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (data.badgeText != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.statusSuccess.withOpacity(0.18)
                            : AppColors.greenTintBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.badgeText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark
                              ? AppColors.statusSuccess
                              : AppColors.greenTintText,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 14),

              // Description Text
              Text(
                data.subtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              if (data.metrics.isNotEmpty) ...[
                const SizedBox(height: 16),

                // Metric Chips Row
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: data.metrics.entries.map<Widget>((entry) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceElevated
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            entry.key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark
                                  ? AppColors.textDarkMuted
                                  : AppColors.textLightMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Open ${data.title}',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? accent : const Color(0xFF0284C7),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: isDark ? accent : const Color(0xFF0284C7),
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
