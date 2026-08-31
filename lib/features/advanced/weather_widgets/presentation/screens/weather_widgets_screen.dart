import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mausam_app/core/theme/app_colors.dart';

class WeatherWidgetConfig {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool isEnabled;

  WeatherWidgetConfig({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isEnabled = true,
  });
}

class WeatherWidgetsScreen extends ConsumerStatefulWidget {
  const WeatherWidgetsScreen({super.key});

  @override
  ConsumerState<WeatherWidgetsScreen> createState() =>
      _WeatherWidgetsScreenState();
}

class _WeatherWidgetsScreenState extends ConsumerState<WeatherWidgetsScreen> {
  final List<WeatherWidgetConfig> _widgets = [
    WeatherWidgetConfig(
        id: 'w-hero',
        title: 'Current Weather Hero',
        description: 'Temperature, condition, min/max',
        icon: Icons.wb_sunny_rounded),
    WeatherWidgetConfig(
        id: 'w-disaster',
        title: 'Disaster Emergency Alert',
        description: 'Active cyclones & severe advisories',
        icon: Icons.warning_amber_rounded),
    WeatherWidgetConfig(
        id: 'w-nowcast',
        title: 'Rain Nowcast (60-Min)',
        description: 'Short-term rain windows',
        icon: Icons.umbrella_rounded),
    WeatherWidgetConfig(
        id: 'w-aqi',
        title: 'Air Quality Index',
        description: 'PM2.5 / PM10 health status',
        icon: Icons.blur_on_rounded),
    WeatherWidgetConfig(
        id: 'w-earthquake',
        title: 'Earthquake Monitor',
        description: 'Seismic events & magnitude',
        icon: Icons.vibration_rounded),
    WeatherWidgetConfig(
        id: 'w-cyclone',
        title: 'Cyclone Tracker',
        description: 'Storm trajectory & landfall',
        icon: Icons.cyclone),
    WeatherWidgetConfig(
        id: 'w-lightning',
        title: 'Lightning Radar',
        description: 'Strike density & proximity',
        icon: Icons.flash_on_rounded),
    WeatherWidgetConfig(
        id: 'w-route',
        title: 'Smart Route Commute',
        description: 'Waypoint rain & visibility',
        icon: Icons.alt_route_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackgroundSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Configurable Home Widgets',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _widgets.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _widgets.removeAt(oldIndex);
            _widgets.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final item = _widgets[index];
          return Container(
            key: ValueKey(item.id),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.darkBackgroundSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
            ),
            child: ListTile(
              leading: Icon(item.icon, color: AppColors.cyanAccent, size: 22),
              title: Text(
                item.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                item.description,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: item.isEnabled,
                    activeColor: AppColors.cyanAccent,
                    onChanged: (val) {
                      setState(() {
                        item.isEnabled = val;
                      });
                    },
                  ),
                  const Icon(Icons.drag_handle_rounded,
                      color: AppColors.textMuted),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
