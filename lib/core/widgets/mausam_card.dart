import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

class MausamCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final bool hasGlow;
  final Color? glowColor;

  const MausamCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.gradient,
    this.width,
    this.height,
    this.hasGlow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final defaultBorder = Border.all(
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      width: 1,
    );

    Widget content = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? defaultBg) : null,
        gradient: gradient,
        borderRadius: AppRadius.brLg,
        border: border ?? defaultBorder,
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (glowColor ?? AppColors.primaryBlue).withOpacity(0.25),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                )
              ]
            : (isDark ? AppShadows.darkCard : AppShadows.lightCard),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.brLg,
          onTap: onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}
