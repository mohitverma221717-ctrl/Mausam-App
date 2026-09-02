import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../features/location/presentation/providers/location_provider.dart';
import '../../features/alerts/presentation/providers/alerts_provider.dart';
import 'live_clock_widget.dart';

class MausamAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLocationPicker;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showDrawerButton;
  final VoidCallback? onLocationTap;

  const MausamAppBar({
    super.key,
    this.title,
    this.showLocationPicker = true,
    this.actions,
    this.showBackButton = false,
    this.showDrawerButton = true,
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
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: showBackButton || showDrawerButton ? 0 : 16,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                ),
                tooltip: 'Back',
                onPressed: () => context.pop(),
              ),
            )
          : (showDrawerButton
              ? Builder(
                  builder: (ctx) => Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceCard
                              : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.menu_rounded,
                          size: 20,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                        ),
                      ),
                      tooltip: 'Open navigation menu',
                      onPressed: () {
                        Scaffold.of(ctx).openDrawer();
                      },
                    ),
                  ),
                )
              : null),
      title: showLocationPicker
          ? InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onLocationTap ?? () => context.push('/locations/select'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF261D11)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFD97706),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                                    fontSize: 17,
                                    letterSpacing: -0.2,
                                    color: isDark
                                        ? AppColors.textDarkPrimary
                                        : AppColors.textLightPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: isDark
                                    ? AppColors.accentCyan
                                    : const Color(0xFFD97706),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  '${locationState.selectedLocation.state} · ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.textDarkMuted
                                        : AppColors.textLightMuted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const LiveClockWidget(
                                style: LiveClockStyle.inlineText,
                                showDate: true,
                              ),
                            ],
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
                fontSize: 20,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
      actions: actions ??
          [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: LiveClockWidget(
                  style: LiveClockStyle.pill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: InkWell(
                onTap: () => context.push('/alerts/notifications'),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurface,
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      width: 1,
                    ),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                      if (alertsState.unreadNotificationsCount > 0)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkSurfaceCard
                                    : AppColors.lightSurface,
                                width: 1.5,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                alertsState.unreadNotificationsCount > 99
                                    ? '99+'
                                    : '${alertsState.unreadNotificationsCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
    );
  }

}

