import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

enum ButtonVariant { primary, secondary, outline, text }

class MausamButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final Color? customColor;

  const MausamButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 50.0,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    if (variant == ButtonVariant.primary) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: AppRadius.brMd,
          gradient: customColor != null
              ? null
              : const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryBlueLight],
                ),
          color: customColor,
          boxShadow: [
            BoxShadow(
              color: (customColor ?? AppColors.primaryBlue).withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          onPressed: isLoading ? null : onPressed,
          child: childContent,
        ),
      );
    }

    if (variant == ButtonVariant.secondary) {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? AppColors.darkSurfaceElevated
                : AppColors.lightBackgroundSecondary,
            foregroundColor:
                isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.brMd,
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          onPressed: isLoading ? null : onPressed,
          child: childContent,
        ),
      );
    }

    if (variant == ButtonVariant.outline) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: customColor ??
                (isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary),
            side: BorderSide(
              color: customColor ??
                  (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: 1.5,
            ),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          onPressed: isLoading ? null : onPressed,
          child: childContent,
        ),
      );
    }

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: childContent,
    );
  }
}
