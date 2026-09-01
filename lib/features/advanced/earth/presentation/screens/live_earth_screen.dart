import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/earth/domain/models/earth_layer_model.dart';
import 'package:mausam_app/features/advanced/earth/domain/repositories/earth_repository.dart';
import 'package:mausam_app/features/advanced/earth/presentation/widgets/earth_4d_timeline_bar.dart';
import 'package:mausam_app/features/advanced/earth/presentation/widgets/earth_globe_canvas.dart';

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
  }

  void _snapToUserLocation() {
    setState(() {
      _zoomLevel = 1.3;
      _panOffset = const Offset(0, 20);
      _yawAngle = 0.4;
      _pitchAngle = 0.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final layersAsync = ref.watch(availableEarthLayersProvider);

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
                  onPanUpdate: (delta) {
                    setState(() {
                      _panOffset += delta;
                      _yawAngle += delta.dx * 0.005;
                      _pitchAngle += delta.dy * 0.005;
                    });
                  },
                  onMarkerTap: (marker) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${marker.title} • ${marker.subtitle}'),
                        backgroundColor: AppColors.darkBackgroundSecondary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
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
                    color: AppColors.darkBackgroundSecondary.withOpacity(0.9),
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
                            const Text(
                              'New Delhi • 32°C Sunny • RSMC Live',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
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
                          if (_zoomLevel < 2.4) _zoomLevel += 0.25;
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
                      onPressed: _snapToUserLocation,
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

