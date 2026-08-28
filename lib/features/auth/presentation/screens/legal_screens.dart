import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Acceptance of Terms', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'By accessing and using MAUSAM, you acknowledge and agree to be bound by these terms. MAUSAM provides meteorological insights, personalized forecasts, and smart warnings based on official meteorological datasets.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('2. Informational Purpose', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Weather forecasts, agricultural insights, pollen indicators, and marine status provided in the app are for informational planning purposes. Extreme weather decisions must follow directives from national disaster management authorities.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('3. Data Sources', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Official observations and radar scans are ingested from accredited meteorological agencies including the India Meteorological Department (IMD) and global radar networks.',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Location Information', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'MAUSAM uses foreground and background location data solely to fetch hyperlocal weather forecasts, radar animations, and immediate storm alerts. Your exact coordinates are never sold or shared with advertisers.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('2. Local Storage & Preferences',
                style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'User interests, priority rankings, saved places, and customized notification preferences are stored securely on your device using encrypted storage.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('3. Data Protection', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'All network communications are encrypted with standard TLS 1.3 to ensure absolute privacy and security.',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
