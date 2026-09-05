import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_text_field.dart';
import '../../domain/models/location_model.dart';
import '../providers/location_provider.dart';

class SelectLocationScreen extends ConsumerStatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  ConsumerState<SelectLocationScreen> createState() =>
      _SelectLocationScreenState();
}

class _SelectLocationScreenState extends ConsumerState<SelectLocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onLocationSelected(LocationModel loc) {
    ref.read(locationProvider.notifier).selectLocation(loc);
    final fromOnboarding =
        GoRouterState.of(context).uri.queryParameters['from'] == 'onboarding';
    if (fromOnboarding) {
      context.go('/personalization/interests');
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/personalization/interests');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = ref.watch(locationProvider);
    final locationNotifier = ref.read(locationProvider.notifier);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Select Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined, color: AppColors.accentCyan),
            tooltip: 'Pick on Map',
            onPressed: () => context.push('/locations/map-picker'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              MausamTextField(
                controller: _searchController,
                hintText: 'Search city, state or place...',
                prefixIcon: Icons.search_rounded,
                onChanged: (val) => locationNotifier.search(val),
              ),
              const SizedBox(height: 20),

              // Use Current Location CTA
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceCard
                      : AppColors.lightSurfaceCard,
                  borderRadius: AppRadius.brLg,
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primaryBlue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Location',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${locationState.selectedLocation.name}, ${locationState.selectedLocation.state}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        backgroundColor: AppColors.primaryBlue,
                      ),
                      onPressed: () {
                        _onLocationSelected(locationState.selectedLocation);
                      },
                      child:
                          const Text('Use GPS', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Search Results (if searching)
              if (_searchController.text.isNotEmpty) ...[
                Text(
                  'Search Results',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: locationState.searchResults.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final loc = locationState.searchResults[index];
                    return _LocationListTile(
                      location: loc,
                      onTap: () => _onLocationSelected(loc),
                    );
                  },
                ),
              ] else ...[
                // Recent Locations
                Text(
                  'Recent Locations',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: locationState.savedLocations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final loc = locationState.savedLocations[index];
                    return _LocationListTile(
                      location: loc,
                      onTap: () => _onLocationSelected(loc),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Popular Cities
                Text(
                  'Popular Cities',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: locationState.popularCities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final loc = locationState.popularCities[index];
                    return _LocationListTile(
                      location: loc,
                      onTap: () => _onLocationSelected(loc),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationListTile extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;

  const _LocationListTile({
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brMd,
        side: BorderSide(
          color:
              isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : AppColors.lightBackgroundSecondary,
            borderRadius: AppRadius.brSm,
          ),
          child: Icon(
            location.category.iconData,
            size: 20,
            color: AppColors.accentCyan,
          ),
        ),
        title: Row(
          children: [
            Text(
              location.name,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            if (location.category != LocationCategory.custom) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  location.category.displayName,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.primaryBlueLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          location.formattedAddress,
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
          ),
        ),
        trailing: location.currentTemp != null
            ? Text(
                '${location.currentTemp!.toInt()}°C',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              )
            : const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      ),
    );
  }
}
