import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../features/location/presentation/providers/location_provider.dart';
import '../../features/alerts/presentation/providers/alerts_provider.dart';

class MausamAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLocationPicker;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onLocationTap;

  const MausamAppBar({
    super.key,
    this.title,
    this.showLocationPicker = true,
    this.actions,
    this.showBackButton = false,
    this.onLocationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);
    final alertsState = ref.watch(alertsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            )
          : null,
      title: showLocationPicker
          ? InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onLocationTap ?? () => context.push('/locations/select'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  locationState.selectedLocation.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: AppColors.accentCyan,
                              ),
                            ],
                          ),
                          Text(
                            locationState.selectedLocation.state,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textDarkMuted
                                  : AppColors.textLightMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Text(
              title ?? '',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
      actions: actions ??
          [
            // Notification Center with Badge
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 24),
                  onPressed: () => context.push('/alerts/notifications'),
                ),
                if (alertsState.unreadNotificationsCount > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.statusDanger,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 4),
          ],
    );
  }
}
