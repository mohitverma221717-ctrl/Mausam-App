import 'package:flutter/material.dart';
import 'package:mausam_app/core/theme/app_colors.dart';

/// Reusable loading state widget for advanced intelligence modules.
class AdvancedLoadingState extends StatelessWidget {
  final String message;
  const AdvancedLoadingState({
    super.key,
    this.message = 'Fetching weather intelligence data...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyanAccent),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable error state widget for advanced modules.
class AdvancedErrorState extends StatelessWidget {
  final String title;
  final String error;
  final VoidCallback onRetry;

  const AdvancedErrorState({
    super.key,
    this.title = 'Unable to Load Data',
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyanAccent,
                foregroundColor: AppColors.darkBackground,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable empty state widget.
class AdvancedEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const AdvancedEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable data source transparency badge.
class DataSourceBadge extends StatelessWidget {
  final String source;
  final String lastUpdated;
  final bool isDemo;

  const DataSourceBadge({
    super.key,
    required this.source,
    required this.lastUpdated,
    this.isDemo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDemo
            ? Colors.orange.withOpacity(0.12)
            : AppColors.darkBackgroundSecondary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDemo
              ? Colors.orange.withOpacity(0.3)
              : AppColors.glassBorder.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDemo ? Icons.science_rounded : Icons.verified_user_outlined,
            size: 12,
            color: isDemo ? Colors.orangeAccent : AppColors.cyanAccent,
          ),
          const SizedBox(width: 6),
          Text(
            isDemo
                ? 'Demo Data • Source: $source'
                : 'Source: $source • $lastUpdated',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDemo ? Colors.orangeAccent : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
