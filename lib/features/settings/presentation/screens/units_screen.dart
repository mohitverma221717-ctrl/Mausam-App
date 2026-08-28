import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/settings_provider.dart';
import '../../domain/models/app_settings.dart';

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Units & Formats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _UnitSection(
            title: 'Temperature',
            currentValue: settings.temperatureUnit == TemperatureUnit.celsius
                ? 'Celsius (°C)'
                : 'Fahrenheit (°F)',
            options: const ['Celsius (°C)', 'Fahrenheit (°F)'],
            onSelect: (val) {
              notifier.setTemperatureUnit(
                val.contains('Celsius')
                    ? TemperatureUnit.celsius
                    : TemperatureUnit.fahrenheit,
              );
            },
          ),
          const SizedBox(height: 16),
          _UnitSection(
            title: 'Wind Speed',
            currentValue: settings.windUnit == WindUnit.kmh
                ? 'Kilometers per hour (km/h)'
                : 'Miles per hour (mph)',
            options: const [
              'Kilometers per hour (km/h)',
              'Miles per hour (mph)'
            ],
            onSelect: (val) {
              notifier.setWindUnit(
                val.contains('Kilometers') ? WindUnit.kmh : WindUnit.mph,
              );
            },
          ),
          const SizedBox(height: 16),
          _UnitSection(
            title: 'Atmospheric Pressure',
            currentValue: settings.pressureUnit == PressureUnit.hpa
                ? 'Hectopascals (hPa)'
                : 'Inches of Mercury (inHg)',
            options: const ['Hectopascals (hPa)', 'Inches of Mercury (inHg)'],
            onSelect: (val) {
              notifier.setPressureUnit(
                val.contains('Hectopascals')
                    ? PressureUnit.hpa
                    : PressureUnit.inHg,
              );
            },
          ),
          const SizedBox(height: 16),
          _UnitSection(
            title: 'Distance & Visibility',
            currentValue: settings.distanceUnit == DistanceUnit.km
                ? 'Kilometers (km)'
                : 'Miles (mi)',
            options: const ['Kilometers (km)', 'Miles (mi)'],
            onSelect: (val) {
              notifier.setDistanceUnit(
                val.contains('Kilometers')
                    ? DistanceUnit.km
                    : DistanceUnit.miles,
              );
            },
          ),
          const SizedBox(height: 16),
          _UnitSection(
            title: 'Time Display',
            currentValue: settings.timeFormat == TimeFormat.format12h
                ? '12-Hour (05:46 PM)'
                : '24-Hour (17:46)',
            options: const ['12-Hour (05:46 PM)', '24-Hour (17:46)'],
            onSelect: (val) {
              notifier.setTimeFormat(
                val.contains('12-Hour')
                    ? TimeFormat.format12h
                    : TimeFormat.format24h,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UnitSection extends StatelessWidget {
  final String title;
  final String currentValue;
  final List<String> options;
  final ValueChanged<String> onSelect;

  const _UnitSection({
    required this.title,
    required this.currentValue,
    required this.options,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brLg,
        side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
          ),
          ...options.map((opt) {
            final isSelected = opt == currentValue;
            return RadioListTile<String>(
              value: opt,
              groupValue: currentValue,
              activeColor: AppColors.primaryBlue,
              title: Text(
                opt,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              onChanged: (val) {
                if (val != null) onSelect(val);
              },
            );
          }),
        ],
      ),
    );
  }
}
