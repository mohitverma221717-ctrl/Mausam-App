import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/core/theme/app_typography.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/earth/domain/models/earth_layer_model.dart';
import 'package:mausam_app/features/advanced/earth/domain/repositories/earth_repository.dart';
import 'package:mausam_app/features/advanced/earth/presentation/widgets/earth_4d_timeline_bar.dart';
import 'package:mausam_app/features/advanced/earth/presentation/widgets/earth_globe_canvas.dart';
import 'package:mausam_app/features/location/presentation/providers/location_provider.dart';
import 'package:mausam_app/features/weather/presentation/providers/weather_provider.dart';

class LiveEarthScreen extends ConsumerStatefulWidget {
  const LiveEarthScreen({super.key});

  @override
  ConsumerState<LiveEarthScreen> createState() => _LiveEarthScreenState();
}

class _LiveEarthScreenState extends ConsumerState<LiveEarthScreen> {
  EarthLayerType _selectedLayer = EarthLayerType.temperature;
  bool _is3DView = true;
  double _zoomLevel = 1.0;
  Offset _panOffset = Offset.zero;
  double _yawAngle = 0.0;
  double _pitchAngle = 0.0;

  int _selectedHourOffset = 0;
  bool _isPlaying4D = false;

  void _resetCamera() {
    setState(() {
      _zoomLevel = 1.0;
      _panOffset = Offset.zero;
      _yawAngle = 0.0;
      _pitchAngle = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera view reset to default global perspective'),
        backgroundColor: AppColors.darkBackgroundSecondary,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _snapToUserLocation(double lat, double lon, String cityName) {
    final yaw = (lon * math.pi / 180.0);
    final pitch = (lat * math.pi / 180.0);

    setState(() {
      _zoomLevel = 1.4;
      _panOffset = Offset.zero;
      _yawAngle = yaw;
      _pitchAngle = pitch;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Centered camera on $cityName (${lat.toStringAsFixed(2)}°, ${lon.toStringAsFixed(2)}°)'),
        backgroundColor: AppColors.darkBackgroundSecondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showMarkerDetailSheet(BuildContext context, EarthGlobeMarker marker) {
    final weatherState = ref.read(weatherProvider);
    final weather = weatherState.currentWeather;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBackgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: marker.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(marker.icon, color: marker.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker.title,
                          style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          marker.subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.darkSurfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTelemetryStat(
                      'Latitude',
                      '${marker.lat.toStringAsFixed(2)}°',
                      Icons.navigation_rounded,
                    ),
                    _buildTelemetryStat(
                      'Longitude',
                      '${marker.lon.toStringAsFixed(2)}°',
                      Icons.map_rounded,
                    ),
                    _buildTelemetryStat(
                      'Layer Metric',
                      '${_selectedLayer.title} (${_selectedLayer.unitLabel})',
                      _selectedLayer.icon,
                    ),
                  ],
                ),
              ),
              if (weather != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTelemetryStat('Temp', '${weather.temperature.toInt()}°C', Icons.thermostat_rounded),
                      _buildTelemetryStat('Humidity', '${weather.humidity}%', Icons.water_drop_rounded),
                      _buildTelemetryStat('Wind', '${weather.windSpeed.toInt()} km/h', Icons.air_rounded),
                      _buildTelemetryStat('AQI', '${weather.aqi}', Icons.blur_on_rounded),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTelemetryStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.accentCyan),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final layersAsync = ref.watch(availableEarthLayersProvider);
    final locationState = ref.watch(locationProvider);
    final weatherState = ref.watch(weatherProvider);

    final selectedLoc = locationState.selectedLocation;
    final currentWeather = weatherState.currentWeather;

    final markers = [
      EarthGlobeMarker(
        id: 'marker-user',
        title: selectedLoc.name,
        subtitle: currentWeather != null
            ? '${currentWeather.temperature.toInt()}°C • ${currentWeather.condition}'
            : selectedLoc.state,
        lat: selectedLoc.lat,
        lon: selectedLoc.lon,
        icon: Icons.my_location_rounded,
        color: AppColors.cyanAccent,
      ),
      const EarthGlobeMarker(
        id: 'marker-mumbai',
        title: 'Mumbai',
        subtitle: '30°C • Humid Coast',
        lat: 19.07,
        lon: 72.87,
        icon: Icons.location_city_rounded,
        color: Colors.lightBlueAccent,
      ),
      const EarthGlobeMarker(
        id: 'marker-remal',
        title: 'Cyclone REMAL',
        subtitle: 'Severe Storm • 110 km/h',
        lat: 19.8,
        lon: 88.4,
        icon: Icons.cyclone_rounded,
        color: Colors.redAccent,
      ),
      const EarthGlobeMarker(
        id: 'marker-london',
        title: 'London',
        subtitle: '18°C • Light Rain',
        lat: 51.50,
        lon: -0.12,
        icon: Icons.location_on_rounded,
        color: Colors.orangeAccent,
      ),
      const EarthGlobeMarker(
        id: 'marker-tokyo',
        title: 'Tokyo',
        subtitle: '24°C • Clear Sky',
        lat: 35.67,
        lon: 139.65,
        icon: Icons.location_on_rounded,
        color: Colors.purpleAccent,
      ),
    ];

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
          'Live Earth & 4D Weather',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _is3DView ? Icons.public_rounded : Icons.map_rounded,
              color: AppColors.cyanAccent,
            ),
            tooltip: _is3DView ? 'Switch to 2D Map' : 'Switch to 3D Globe',
            onPressed: () {
              setState(() {
                _is3DView = !_is3DView;
              });
            },
          ),
        ],
      ),
      body: layersAsync.when(
        data: (layers) {
          final activeLayer = layers.firstWhere(
            (l) => l.type == _selectedLayer,
            orElse: () => layers.first,
          );

          return Stack(
            children: [
              // Interactive Earth 3D/2D Canvas Viewport
              Positioned.fill(
                child: EarthGlobeCanvas(
                  is3DView: _is3DView,
                  selectedLayer: _selectedLayer,
                  hourOffset: _selectedHourOffset,
                  zoomLevel: _zoomLevel,
                  panOffset: _panOffset,
                  yawAngle: _yawAngle,
                  pitchAngle: _pitchAngle,
                  markers: markers,
                  onPanUpdate: (delta) {
                    setState(() {
                      _panOffset += delta;
                      _yawAngle += delta.dx * 0.005;
                      _pitchAngle += delta.dy * 0.005;
                    });
                  },
                  onZoomChanged: (newZoom) {
                    setState(() {
                      _zoomLevel = newZoom;
                    });
                  },
                  onMarkerTap: (marker) {
                    _showMarkerDetailSheet(context, marker);
                  },
                ),
              ),

              // Top Active Location & Layer Info Header Overlay Card
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackgroundSecondary.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.glassBorder.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _selectedLayer.accentColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_selectedLayer.icon,
                            color: _selectedLayer.accentColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeLayer.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${selectedLoc.name} • ${currentWeather != null ? "${currentWeather.temperature.toInt()}°C ${currentWeather.condition}" : "Live Satellite"} • RSMC Feed',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.cyanAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _is3DView ? '3D GLOBE' : '2D MAP',
                          style: const TextStyle(
                            color: AppColors.cyanAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Active Layer Legend Scale Overlay Widget
              Positioned(
                top: 74,
                left: 14,
                right: 70,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackgroundSecondary.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedLayer.minScaleLabel,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(
                              colors: _selectedLayer.legendColors,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedLayer.maxScaleLabel,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Controls Stack (+ / - / My Location / Reset)
              Positioned(
                right: 14,
                top: 80,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'zoom_in',
                      backgroundColor: AppColors.darkBackgroundSecondary,
                      foregroundColor: AppColors.cyanAccent,
                      tooltip: 'Zoom In',
                      onPressed: () {
                        setState(() {
                          if (_zoomLevel < 2.8) _zoomLevel += 0.25;
                        });
                      },
                      child: const Icon(Icons.add_rounded),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'zoom_out',
                      backgroundColor: AppColors.darkBackgroundSecondary,
                      foregroundColor: AppColors.cyanAccent,
                      tooltip: 'Zoom Out',
                      onPressed: () {
                        setState(() {
                          if (_zoomLevel > 0.6) _zoomLevel -= 0.25;
                        });
                      },
                      child: const Icon(Icons.remove_rounded),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'my_location',
                      backgroundColor: AppColors.darkBackgroundSecondary,
                      foregroundColor: AppColors.cyanAccent,
                      tooltip: 'My Location',
                      onPressed: () => _snapToUserLocation(
                        selectedLoc.lat,
                        selectedLoc.lon,
                        selectedLoc.name,
                      ),
                      child: const Icon(Icons.my_location_rounded),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'reset_view',
                      backgroundColor: AppColors.darkBackgroundSecondary,
                      foregroundColor: AppColors.textSecondary,
                      tooltip: 'Reset View',
                      onPressed: _resetCamera,
                      child: const Icon(Icons.restart_alt_rounded),
                    ),
                  ],
                ),
              ),

              // Layer Chips + 4D Timeline Bar Bottom Sheet Stack
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Horizontal Scrollable 14 Weather Layers Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            AppColors.darkBackgroundSecondary.withOpacity(0.85),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: EarthLayerType.values.map((layerType) {
                            final isSelected = layerType == _selectedLayer;
                            final accent = layerType.accentColor;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                selected: isSelected,
                                selectedColor: accent.withOpacity(0.25),
                                backgroundColor: AppColors.darkBackground,
                                side: BorderSide(
                                  color: isSelected
                                      ? accent
                                      : AppColors.glassBorder.withOpacity(0.4),
                                ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      layerType.icon,
                                      size: 14,
                                      color: isSelected
                                          ? accent
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(layerType.title),
                                  ],
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                onSelected: (_) {
                                  setState(() {
                                    _selectedLayer = layerType;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // 4D Space + Time Telemetry Timeline Bar
                    Earth4dTimelineBar(
                      selectedHourOffset: _selectedHourOffset,
                      onOffsetChanged: (offset) {
                        setState(() {
                          _selectedHourOffset = offset;
                        });
                      },
                      isPlaying: _isPlaying4D,
                      onPlayPauseToggled: (playing) {
                        setState(() {
                          _isPlaying4D = playing;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const AdvancedLoadingState(
          message: 'Rendering live Earth satellite composite & 4D weather...',
        ),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.invalidate(availableEarthLayersProvider),
        ),
      ),
    );
  }
}
