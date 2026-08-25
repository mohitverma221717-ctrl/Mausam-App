import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/alerts_provider.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsState = ref.watch(alertsProvider);
    final alertsNotifier = ref.read(alertsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Notification Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => alertsNotifier.clearAllNotifications(),
            child: const Text('Clear All',
                style: TextStyle(color: AppColors.accentCyan)),
          ),
        ],
      ),
      body: alertsState.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined,
                      size: 48, color: AppColors.textDarkMuted),
                  const SizedBox(height: 12),
                  Text('No notifications', style: AppTypography.titleLarge),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: alertsState.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notif = alertsState.notifications[index];

                return InkWell(
                  borderRadius: AppRadius.brLg,
                  onTap: () => alertsNotifier.markNotificationAsRead(notif.id),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: notif.isRead
                          ? (isDark
                              ? AppColors.darkSurfaceCard
                              : AppColors.lightSurfaceCard)
                          : (isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.lightBackgroundSecondary),
                      borderRadius: AppRadius.brLg,
                      border: Border.all(
                        color: notif.isRead
                            ? (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder)
                            : AppColors.primaryBlue,
                        width: notif.isRead ? 1.0 : 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.18),
                            borderRadius: AppRadius.brSm,
                          ),
                          child: const Icon(Icons.notifications_active_rounded,
                              color: AppColors.accentCyan, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notif.title,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: notif.isRead
                                          ? FontWeight.w600
                                          : FontWeight.w800,
                                      color: isDark
                                          ? AppColors.textDarkPrimary
                                          : AppColors.textLightPrimary,
                                    ),
                                  ),
                                  if (!notif.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.body,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLightSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
