import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class WeatherMetricTile extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? accentColor;
  final double? progress; // 0.0 to 1.0
  final VoidCallback? onTap;

  const WeatherMetricTile({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.accentColor,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = accentColor ?? AppColors.primaryBlue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.brLg,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
            borderRadius: AppRadius.brLg,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textDarkMuted
                            : AppColors.textLightMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, size: 18, color: color),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.metricValue.copyWith(
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (progress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
