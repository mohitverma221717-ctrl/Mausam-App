import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/earth/domain/models/earth_layer_model.dart';
import 'package:mausam_app/features/advanced/earth/domain/repositories/earth_repository.dart';

class LiveEarthScreen extends ConsumerStatefulWidget {
  const LiveEarthScreen({super.key});

  @override
  ConsumerState<LiveEarthScreen> createState() => _LiveEarthScreenState();
}

class _LiveEarthScreenState extends ConsumerState<LiveEarthScreen> {
  EarthLayerType _selectedLayer = EarthLayerType.clouds;
  bool _is3DView = false;
  double _zoomLevel = 1.0;

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
          'Live Earth & Satellite Monitor',
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
              // Earth Globe / Map Simulation Canvas
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF030712),
                  child: Center(
                    child: Transform.scale(
                      scale: _zoomLevel,
                      child: Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.cyanAccent.withOpacity(0.3),
                              const Color(0xFF0284C7).withOpacity(0.4),
                              const Color(0xFF0F172A),
                            ],
                            stops: const [0.2, 0.7, 1.0],
                          ),
                          border: Border.all(
                            color: AppColors.cyanAccent.withOpacity(0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyanAccent.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              _is3DView
                                  ? Icons.public_rounded
                                  : Icons.map_outlined,
                              size: 200,
                              color: AppColors.cyanAccent.withOpacity(0.4),
                            ),
                            Positioned(
                              top: 100,
                              left: 140,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Overlay Control Panels
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackgroundSecondary.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.glassBorder.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(activeLayer.type.icon,
                          color: AppColors.cyanAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeLayer.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              activeLayer.description,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
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

              // Zoom Controls
              Positioned(
                right: 16,
                bottom: 110,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'zoom_in',
                      backgroundColor: AppColors.darkBackgroundSecondary,
                      foregroundColor: AppColors.cyanAccent,
                      onPressed: () {
                        setState(() {
                          if (_zoomLevel < 1.8) _zoomLevel += 0.2;
                        });
                      },
                      child: const Icon(Icons.add_rounded),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'zoom_out',
                      backgroundColor: AppColors.darkBackgroundSecondary,
                      foregroundColor: AppColors.cyanAccent,
                      onPressed: () {
                        setState(() {
                          if (_zoomLevel > 0.8) _zoomLevel -= 0.2;
                        });
                      },
                      child: const Icon(Icons.remove_rounded),
                    ),
                  ],
                ),
              ),

              // Bottom Layer Selector Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackgroundSecondary.withOpacity(0.95),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border.all(
                        color: AppColors.glassBorder.withOpacity(0.5)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: EarthLayerType.values.map((layerType) {
                            final isSelected = layerType == _selectedLayer;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: FilterChip(
                                selected: isSelected,
                                label: Row(
                                  children: [
                                    Icon(
                                      layerType.icon,
                                      size: 14,
                                      color: isSelected
                                          ? AppColors.darkBackground
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(layerType.title),
                                  ],
                                ),
                                selectedColor: AppColors.cyanAccent,
                                backgroundColor: AppColors.darkBackground,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.darkBackground
                                      : AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
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
                      const SizedBox(height: 8),
                      const DataSourceBadge(
                        source: 'EUMETSAT & Open-Meteo Satellite Feed',
                        lastUpdated: 'Live Composite',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const AdvancedLoadingState(
          message: 'Rendering live Earth satellite composite imagery...',
        ),
        error: (err, _) => AdvancedErrorState(
          error: err.toString(),
          onRetry: () => ref.refresh(availableEarthLayersProvider),
        ),
      ),
    );
  }
}
