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
    final condition = overrideCondition ??
        weatherState.currentWeather?.conditionType ??
        WeatherConditionType.sunny;

    return Stack(
      children: [
        // Layer 1: GPU-Accelerated 3D Dynamic Weather Visuals (Non-blocking touch layer)
        Positioned.fill(
          child: IgnorePointer(
            child: Weather3dVisualCanvas(
              conditionType: condition,
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
}
