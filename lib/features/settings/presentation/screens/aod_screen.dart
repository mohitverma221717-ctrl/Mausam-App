import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

class AodScreen extends ConsumerStatefulWidget {
  const AodScreen({super.key});

  @override
  ConsumerState<AodScreen> createState() => _AodScreenState();
}

class _AodScreenState extends ConsumerState<AodScreen> {
  bool _aodEnabled = true;
  bool _showWeather = true;
  bool _showBattery = true;
  bool _nightDimming = true;
  int _selectedStyleIndex = 0;

  final List<String> _styles = [
    'Classic Ambient',
    'Weather Glance',
    'Minimal Clock',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = ref.watch(locationProvider).selectedLocation;
    final weatherState = ref.watch(weatherProvider);
    final currentWeather = weatherState.currentWeather;

    final temp = currentWeather != null
        ? '${currentWeather.temperature.round()}°'
        : '29°';
    final condition = currentWeather?.condition ?? 'Partly Cloudy';

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Always-On Display (AOD)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // 1. OLED AOD Preview Container
            Center(
              child: Container(
                width: 240,
                height: 380,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white24, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withOpacity(0.12),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AOD Time
                    const Text(
                      '11:30',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Date
                    const Text(
                      'Mon, 25 Aug',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Weather Glance (if enabled)
                    if (_showWeather) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wb_sunny_rounded,
                            size: 20,
                            color: Color(0xFFFFB300),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            temp,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        condition,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${location.name}, UP',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Battery & Sensor indicator
                    if (_showBattery)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt_rounded,
                              size: 14, color: AppColors.statusSuccess),
                          SizedBox(width: 4),
                          Text(
                            '85% • Charging',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. AOD Activation Switch
            Material(
              color: isDark
                  ? AppColors.darkSurfaceCard
                  : AppColors.lightSurfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.brXl,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: SwitchListTile(
                value: _aodEnabled,
                activeColor: AppColors.primaryBlue,
                activeTrackColor: AppColors.accentCyan.withOpacity(0.4),
                title: Text(
                  'Ambient Weather Display',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                subtitle: Text(
                  'Shows time, temperature, and live weather conditions on standby',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textDarkMuted
                        : AppColors.textLightMuted,
                  ),
                ),
                onChanged: (val) => setState(() => _aodEnabled = val),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Style Selector
            Text(
              'Display Style',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Material(
              color: isDark
                  ? AppColors.darkSurfaceCard
                  : AppColors.lightSurfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.brXl,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: List.generate(_styles.length, (index) {
                  final isSelected = _selectedStyleIndex == index;
                  return ListTile(
                    onTap: () => setState(() => _selectedStyleIndex = index),
                    title: Text(
                      _styles[index],
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded,
                            color: AppColors.accentCyan)
                        : null,
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Detailed Toggles
            Text(
              'Customization & Power Saving',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Material(
              color: isDark
                  ? AppColors.darkSurfaceCard
                  : AppColors.lightSurfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.brXl,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _showWeather,
                    activeColor: AppColors.primaryBlue,
                    title: const Text('Show Live Weather Glance'),
                    subtitle: const Text(
                        'Displays current temperature and sky condition'),
                    onChanged: (v) => setState(() => _showWeather = v),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _showBattery,
                    activeColor: AppColors.primaryBlue,
                    title: const Text('Show Battery Status'),
                    subtitle:
                        const Text('Battery percentage & charging indicator'),
                    onChanged: (v) => setState(() => _showBattery = v),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _nightDimming,
                    activeColor: AppColors.primaryBlue,
                    title: const Text('Night Auto-Dimming'),
                    subtitle: const Text(
                        'Dims display brightness between 11 PM and 6 AM'),
                    onChanged: (v) => setState(() => _nightDimming = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
