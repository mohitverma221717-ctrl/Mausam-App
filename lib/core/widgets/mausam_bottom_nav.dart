import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../localization/app_localizations.dart';

class MausamBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MausamBottomNav({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = navigationShell.currentIndex;

    final navItems = [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: context.tr('home'),
      ),
      _NavItem(
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore_rounded,
        label: context.tr('explore'),
      ),
      _NavItem(
        icon: Icons.radar_outlined,
        activeIcon: Icons.radar_rounded,
        label: context.tr('radar'),
      ),
      _NavItem(
        icon: Icons.notifications_none_rounded,
        activeIcon: Icons.notifications_rounded,
        label: context.tr('alerts'),
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: context.tr('profile'),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.darkBackgroundSecondary : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onItemTapped(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.primaryBlue.withOpacity(0.18)
                                    : AppColors.primaryBlue.withOpacity(0.12))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected
                                ? (isDark
                                    ? AppColors.accentCyan
                                    : AppColors.primaryBlue)
                                : (isDark
                                    ? AppColors.textDarkMuted
                                    : AppColors.textLightMuted),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.primaryBlue)
                                : (isDark
                                    ? AppColors.textDarkMuted
                                    : AppColors.textLightMuted),
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
