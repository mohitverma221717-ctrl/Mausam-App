import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';
import '../../features/weather/presentation/providers/weather_provider.dart';
import 'weather_3d_background_layer.dart';
import 'weather_3d_icon_widget.dart';

/// Weather3dShowcaseCard
/// Renders real-time 3D weather visual matching the current location's weather state automatically.
class Weather3dShowcaseCard extends ConsumerWidget {
  final WeatherConditionType? overrideCondition;

  const Weather3dShowcaseCard({
    super.key,
    this.overrideCondition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weatherState = ref.watch(weatherProvider);
    final weather = weatherState.currentWeather;

    final condition = Weather3dBackgroundLayer.resolveEffectiveCondition(
      weather,
      overrideCondition,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
              ),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.primaryBlue).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.view_in_ar_rounded,
                        color: AppColors.accentCyan,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3D Dynamic Weather Engine',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textLightPrimary,
                          ),
                        ),
                        Text(
                          weather != null
                              ? 'Automatic Live Real-Time • ${weather.cityName}'
                              : 'GPU Volumetric Lighting & Physics',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'LIVE 3D',
                    style: AppTypography.labelMedium.copyWith(
                      color: const Color(0xFF10B981),
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Main 3D Automatic Real-Time Visual Stage
            Center(
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark
                      ? const Color(0xFF0F172A).withOpacity(0.6)
                      : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? AppColors.accentCyan.withOpacity(0.2)
                        : const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dynamic 3D Volumetric Visual Icon
                    Weather3dIconWidget(
                      key: ValueKey(condition),
                      conditionType: condition,
                      size: 140,
                      animate: true,
                    ),

                    Positioned(
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withOpacity(0.4)
                              : Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.black12,
                          ),
                        ),
                        child: Text(
                          _getConditionTitle(condition),
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textLightPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getConditionTitle(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.sunny:
        return '☀️ 3D Sun & Solar Rays';
      case WeatherConditionType.partlyCloudy:
        return '⛅ 3D Volumetric Cloud & Sun';
      case WeatherConditionType.cloudy:
        return '☁️ 3D Cumulus Layer';
      case WeatherConditionType.rainy:
        return '🌧️ 3D Falling Raindrops';
      case WeatherConditionType.heavyRain:
        return '🌧️ 3D Heavy Downpour';
      case WeatherConditionType.thunderstorm:
        return '🌩️ 3D Lightning Storm';
      case WeatherConditionType.clearNight:
        return '🌙 3D Moon & Starfield';
      case WeatherConditionType.partlyCloudyNight:
        return '🌙 3D Night Clouds';
      case WeatherConditionType.snowy:
        return '❄️ 3D Swaying Snowflakes';
      case WeatherConditionType.foggy:
        return '🌫️ 3D Volumetric Fog';
      case WeatherConditionType.windy:
        return '💨 3D Aerodynamic Wind';
    }
  }
}
