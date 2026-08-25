import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              const Spacer(),
              // Visual Icon Container
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.accentCyan],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.cloud_sync_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Text(
                "Let's Get Started",
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in to continue your personalized weather experience or explore directly.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Login Button
              MausamButton(
                text: 'Login',
                width: double.infinity,
                onPressed: () => context.push('/auth/login'),
              ),
              const SizedBox(height: 14),
              // Sign Up Button
              MausamButton(
                text: 'Sign Up',
                variant: ButtonVariant.secondary,
                width: double.infinity,
                onPressed: () => context.push('/auth/signup'),
              ),
              const SizedBox(height: 14),
              // Guest Quick Explore
              TextButton(
                onPressed: () => context.go('/location/permission'),
                child: Text(
                  'Continue as Guest',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textDarkMuted
                        : AppColors.textLightMuted,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
