import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/location/presentation/providers/location_provider.dart';
import '../../features/weather/presentation/providers/weather_provider.dart';

class _DrawerModuleItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color accentColor;

  const _DrawerModuleItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.accentColor,
  });
}

class MausamModuleDrawer extends ConsumerWidget {
  const MausamModuleDrawer({super.key});

  static const List<_DrawerModuleItem> _modules = [
    _DrawerModuleItem(
      title: 'Health & AQI',
      description: 'Air quality, pollen, UV & health insights',
      icon: Icons.favorite_rounded,
      route: '/explore/health',
      accentColor: AppColors.statusSuccess,
    ),
    _DrawerModuleItem(
      title: 'Fitness & Running',
      description: 'Best running hours, heat & outdoor conditions',
      icon: Icons.directions_run_rounded,
      route: '/explore/fitness',
      accentColor: AppColors.accentCyan,
    ),
    _DrawerModuleItem(
      title: 'Marine & Surfing',
      description: 'Tides, waves, wind & sea conditions',
      icon: Icons.waves_rounded,
      route: '/explore/marine',
      accentColor: Color(0xFF00B4D8),
    ),
    _DrawerModuleItem(
      title: 'Travel & Destinations',
      description: 'Destination weather & travel conditions',
      icon: Icons.flight_takeoff_rounded,
      route: '/explore/travel',
      accentColor: Color(0xFF7209B7),
    ),
    _DrawerModuleItem(
      title: 'Family & School',
      description: 'School commute, rain & family alerts',
      icon: Icons.family_restroom_rounded,
      route: '/explore/family',
      accentColor: Color(0xFFF77F00),
    ),
    _DrawerModuleItem(
      title: 'Agriculture & Farm',
      description: 'Rainfall, soil moisture & farm conditions',
      icon: Icons.agriculture_rounded,
      route: '/explore/agriculture',
      accentColor: Color(0xFF55A630),
    ),
    _DrawerModuleItem(
      title: 'Commute',
      description: 'Traffic, visibility, rain & road conditions',
      icon: Icons.directions_car_rounded,
      route: '/explore/commute',
      accentColor: Color(0xFF4361EE),
    ),
    _DrawerModuleItem(
      title: 'Event Planner',
      description: 'Rain probability, comfort & outdoor suitability',
      icon: Icons.event_available_rounded,
      route: '/explore/event-planner',
      accentColor: Color(0xFFFF0054),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = ref.watch(locationProvider);
    final weatherState = ref.watch(weatherProvider);
    final currentWeather = weatherState.currentWeather;

    String? currentPath;
    try {
      currentPath = GoRouterState.of(context).uri.path;
    } catch (_) {
      currentPath = null;
    }

    return Drawer(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Drawer Header (Branding & Active Location)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard
                    : AppColors.lightSurfaceCard,
                border: Border(
                  bottom: BorderSide(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/mausam_logo.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'MAUSAM',
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.textLightPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.accentCyan.withOpacity(0.18),
                                    borderRadius: AppRadius.brPill,
                                  ),
                                  child: const Text(
                                    'PRO',
                                    style: TextStyle(
                                      color: AppColors.accentCyan,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Personalized Weather',
                              style: AppTypography.labelSmall.copyWith(
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
                  const SizedBox(height: 14),

                  // Location & Current Weather Pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightBackgroundSecondary,
                      borderRadius: AppRadius.brMd,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorderSubtle
                            : AppColors.lightBorderSubtle,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${locationState.selectedLocation.name}, ${locationState.selectedLocation.state}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                        ),
                        if (currentWeather != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${currentWeather.temperature.round()}°C',
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Specialized Modules List
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text(
                      'SPECIALIZED MODULES',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textDarkMuted
                            : AppColors.textLightMuted,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  ..._modules.map((module) {
                    final isCurrentRoute = currentPath == module.route;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: AppRadius.brLg,
                          onTap: () {
                            Navigator.of(context).pop(); // Close drawer
                            if (!isCurrentRoute) {
                              try {
                                context.push(module.route);
                              } catch (_) {}
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: isCurrentRoute
                                  ? (isDark
                                      ? AppColors.primaryBlue.withOpacity(0.18)
                                      : AppColors.primaryBlue.withOpacity(0.12))
                                  : Colors.transparent,
                              borderRadius: AppRadius.brLg,
                              border: Border.all(
                                color: isCurrentRoute
                                    ? AppColors.primaryBlue.withOpacity(0.6)
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: module.accentColor
                                        .withOpacity(isDark ? 0.16 : 0.12),
                                    borderRadius: AppRadius.brMd,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      module.icon,
                                      size: 20,
                                      color: module.accentColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        module.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            AppTypography.titleSmall.copyWith(
                                          fontWeight: isCurrentRoute
                                              ? FontWeight.w800
                                              : FontWeight.w700,
                                          color: isCurrentRoute
                                              ? (isDark
                                                  ? Colors.white
                                                  : AppColors.primaryBlue)
                                              : (isDark
                                                  ? AppColors.textDarkPrimary
                                                  : AppColors.textLightPrimary),
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        module.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark
                                              ? AppColors.textDarkMuted
                                              : AppColors.textLightMuted,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: isCurrentRoute
                                      ? AppColors.accentCyan
                                      : (isDark
                                          ? AppColors.textDarkMuted
                                          : AppColors.textLightMuted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Divider(
                    color: isDark
                        ? AppColors.darkBorderSubtle
                        : AppColors.lightBorderSubtle,
                    height: 1,
                  ),
                  const SizedBox(height: 8),

                  // Secondary Settings & Help
                  _DrawerSecondaryTile(
                    icon: Icons.tune_rounded,
                    title: 'Units & Measurements',
                    onTap: () {
                      Navigator.of(context).pop();
                      try {
                        context.push('/profile/units');
                      } catch (_) {}
                    },
                    isDark: isDark,
                  ),
                  _DrawerSecondaryTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notification Center',
                    onTap: () {
                      Navigator.of(context).pop();
                      try {
                        context.push('/alerts/notifications');
                      } catch (_) {}
                    },
                    isDark: isDark,
                  ),
                  _DrawerSecondaryTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Feedback',
                    onTap: () {
                      Navigator.of(context).pop();
                      try {
                        context.push('/profile/help');
                      } catch (_) {}
                    },
                    isDark: isDark,
                  ),
                  _DrawerSecondaryTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Mausam',
                    onTap: () {
                      Navigator.of(context).pop();
                      try {
                        context.push('/profile/about');
                      } catch (_) {}
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerSecondaryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDark;

  const _DrawerSecondaryTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.brMd,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color:
                    isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color:
                    isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
