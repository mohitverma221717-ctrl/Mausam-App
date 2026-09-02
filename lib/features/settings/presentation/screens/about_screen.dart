import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('About MAUSAM'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withOpacity(0.35),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/mausam_logo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'MAUSAM',
              style: AppTypography.headlineLarge.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                color: isDark ? Colors.white : AppColors.textLightPrimary,
              ),
            ),
            Text(
              'Version 1.0.0 (Build 2026.08)',
              style: AppTypography.bodySmall.copyWith(
                color:
                    isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.18),
                borderRadius: AppRadius.brPill,
              ),
              child: Text(
                'Personalized Weather Experience',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard
                    : AppColors.lightSurfaceCard,
                borderRadius: AppRadius.brXl,
                border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the Application',
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'MAUSAM is a hyper-personalized commercial-grade meteorological platform that dynamically prioritizes weather information according to your individual lifestyle: Health, Fitness, Marine, Travel, Family, Agriculture, Commute, and Event Planning.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    'Attribution & Data Partners:',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• India Meteorological Department (IMD)\n• Ministry of Earth Sciences (MoES)\n• National Center for Medium Range Weather Forecasting (NCMRWF)\n• Central Pollution Control Board (CPCB)',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '© 2026 MAUSAM Meteorological Systems. All rights reserved.',
              style: AppTypography.labelSmall.copyWith(
                color:
                    isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
