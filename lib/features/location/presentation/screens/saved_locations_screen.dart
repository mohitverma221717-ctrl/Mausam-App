import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../../../core/widgets/mausam_text_field.dart';
import '../../domain/models/location_model.dart';
import '../providers/location_provider.dart';

class SavedLocationsScreen extends ConsumerStatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  ConsumerState<SavedLocationsScreen> createState() =>
      _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends ConsumerState<SavedLocationsScreen> {
  void _showAddLocationDialog() {
    final nameCtrl = TextEditingController();
    final stateCtrl = TextEditingController();
    LocationCategory selectedCategory = LocationCategory.custom;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurfaceCard
          : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Location',
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MausamTextField(
                    controller: nameCtrl,
                    label: 'City / Location Name',
                    hintText: 'e.g. Bengaluru, London, Noida',
                  ),
                  const SizedBox(height: 14),
                  MausamTextField(
                    controller: stateCtrl,
                    label: 'State / Country',
                    hintText: 'e.g. Karnataka, India',
                  ),
                  const SizedBox(height: 14),
                  Text('Category', style: AppTypography.labelMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: LocationCategory.values
                        .where((c) => c != LocationCategory.current)
                        .map((cat) {
                      final isSelected = cat == selectedCategory;
                      return ChoiceChip(
                        label: Text(cat.displayName),
                        selected: isSelected,
                        selectedColor: AppColors.primaryBlue,
                        onSelected: (selected) {
                          if (selected) {
                            setSheetState(() {
                              selectedCategory = cat;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  MausamButton(
                    text: 'Save Location',
                    width: double.infinity,
                    onPressed: () {
                      if (nameCtrl.text.trim().isNotEmpty) {
                        final newLoc = LocationModel(
                          id: 'loc-custom-${DateTime.now().millisecondsSinceEpoch}',
                          name: nameCtrl.text.trim(),
                          state: stateCtrl.text.trim().isEmpty
                              ? 'Region'
                              : stateCtrl.text.trim(),
                          country: 'India',
                          lat: 25.0,
                          lon: 80.0,
                          category: selectedCategory,
                          currentTemp: 27.0,
                          currentCondition: 'Partly Cloudy',
                        );
                        ref
                            .read(locationProvider.notifier)
                            .addSavedLocation(newLoc);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        title: const Text('Saved Locations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              'My Places',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Saved Locations List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: locationState.savedLocations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final loc = locationState.savedLocations[index];
                final isSelected = loc.id == locationState.selectedLocation.id;

                return Dismissible(
                  key: Key(loc.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: const BoxDecoration(
                      color: AppColors.statusDanger,
                      borderRadius: AppRadius.brLg,
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white),
                  ),
                  onDismissed: (_) {
                    locationNotifier.removeLocation(loc.id);
                  },
                  child: Material(
                    color: isDark
                        ? AppColors.darkSurfaceCard
                        : AppColors.lightSurfaceCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.brLg,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      onTap: () {
                        locationNotifier.selectLocation(loc);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Switched weather to ${loc.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryBlue.withOpacity(0.2)
                              : (isDark
                                  ? AppColors.darkSurfaceElevated
                                  : AppColors.lightBackgroundSecondary),
                          borderRadius: AppRadius.brMd,
                        ),
                        child: Icon(
                          loc.category.iconData,
                          size: 22,
                          color: isSelected
                              ? AppColors.accentCyan
                              : AppColors.primaryBlueLight,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            loc.name,
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.12),
                              borderRadius: AppRadius.brPill,
                            ),
                            child: Text(
                              loc.category.displayName,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.primaryBlueLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        loc.formattedAddress,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textDarkMuted
                              : AppColors.textLightMuted,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (loc.currentTemp != null)
                            Text(
                              '${loc.currentTemp!.toInt()}°C',
                              style: AppTypography.headlineSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                          const SizedBox(width: 8),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.accentCyan,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Add Location Button
            MausamButton(
              text: '+ Add Location',
              variant: ButtonVariant.secondary,
              width: double.infinity,
              onPressed: _showAddLocationDialog,
            ),
          ],
        ),
      ),
    );
  }
}
