import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/weather/domain/models/weather_data.dart';
import '../../features/weather/presentation/providers/weather_provider.dart';
import 'weather_3d_visual_canvas.dart';

/// Weather3dBackgroundLayer
/// Wraps screen bodies in a non-intrusive GPU-accelerated 3D Weather Animation Layer.
/// Placed behind UI content with IgnorePointer to ensure 100% interactivity of buttons & cards.
class Weather3dBackgroundLayer extends ConsumerWidget {
  final Widget child;
  final WeatherConditionType? overrideCondition;

  const Weather3dBackgroundLayer({
    super.key,
    required this.child,
    this.overrideCondition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final weather = weatherState.currentWeather;
    final condition = resolveEffectiveCondition(weather, overrideCondition);

    return Stack(
      children: [
        // Layer 1: GPU-Accelerated 3D Dynamic Weather Visuals (Non-blocking touch layer)
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 650),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: Weather3dVisualCanvas(
                key: ValueKey(condition),
                conditionType: condition,
              ),
            ),
          ),
        ),

        // Layer 2: Existing Application Content & Interactive UI
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }

  static WeatherConditionType resolveEffectiveCondition(
      WeatherData? weather, WeatherConditionType? overrideCondition) {
    if (overrideCondition != null) {
      return overrideCondition;
    }
    if (weather == null) {
      return WeatherConditionType.sunny;
    }

    if (weather.conditionType == WeatherConditionType.clearNight ||
        weather.conditionType == WeatherConditionType.partlyCloudyNight) {
      return weather.conditionType;
    }

    bool isNightTime = false;
    try {
      final now = DateTime.now();
      final sunriseTime = _parseTimeString(weather.sunrise, now);
      final sunsetTime = _parseTimeString(weather.sunset, now);

      if (sunriseTime != null && sunsetTime != null) {
        if (now.isBefore(sunriseTime) || now.isAfter(sunsetTime)) {
          isNightTime = true;
        }
      }
    } catch (_) {}

    if (isNightTime) {
      if (weather.conditionType == WeatherConditionType.sunny) {
        return WeatherConditionType.clearNight;
      }
      if (weather.conditionType == WeatherConditionType.partlyCloudy) {
        return WeatherConditionType.partlyCloudyNight;
      }
    }

    return weather.conditionType;
  }

  static DateTime? _parseTimeString(String timeStr, DateTime referenceDate) {
    try {
      final cleaned = timeStr.trim().toUpperCase();
      final isPm = cleaned.endsWith('PM');
      final isAm = cleaned.endsWith('AM');
      final timePart = cleaned.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = timePart.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        if (isPm && hour < 12) hour += 12;
        if (isAm && hour == 12) hour = 0;
        return DateTime(
            referenceDate.year, referenceDate.month, referenceDate.day, hour, minute);
      }
    } catch (_) {}
    return null;
  }
}

