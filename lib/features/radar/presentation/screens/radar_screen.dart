import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../location/presentation/providers/location_provider.dart';

enum RadarLayer {
  rain('Rain / Precipitation', Icons.grain_rounded,
      'Doppler Reflectivity (dBZ)'),
  storm('Storm & Lightning', Icons.bolt_rounded, 'Convective Storm Cells'),
  wind('Wind Streamlines', Icons.air_rounded, 'Surface & Upper Wind Vectors'),
  temperature(
      'Temperature Map', Icons.thermostat_rounded, 'Thermal Isotherms (°C)'),
  cloud('Satellite Cloud', Icons.cloud_rounded, 'Infrared Cloud Cover');

  final String label;
  final IconData icon;
  final String subtitle;
  const RadarLayer(this.label, this.icon, this.subtitle);
}

class RadarFrame {
  final String time;
  final String label;
  final bool isForecast;
  final String rainIntensity;
  final double dbz;
  final String movementDirection;
  final int movementSpeedKmH;

  const RadarFrame({
    required this.time,
    required this.label,
    required this.isForecast,
    required this.rainIntensity,
    required this.dbz,
    required this.movementDirection,
    required this.movementSpeedKmH,
  });
}

class RadarScreen extends ConsumerStatefulWidget {
  const RadarScreen({super.key});

  @override
  ConsumerState<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends ConsumerState<RadarScreen>
    with SingleTickerProviderStateMixin {
  RadarLayer _selectedLayer = RadarLayer.rain;
  bool _isPlaying = false;
  int _currentFrameIndex = 3; // Default to NOW frame
  late AnimationController _sweepAnimController;
  Timer? _playbackTimer;
  final TransformationController _transController = TransformationController();

  final List<RadarFrame> _frames = const [
    RadarFrame(
      time: '10:30 AM',
      label: '-90 min',
      isForecast: false,
      rainIntensity: 'Light',
      dbz: 22.0,
      movementDirection: 'NE → SW',
      movementSpeedKmH: 20,
    ),
    RadarFrame(
      time: '11:00 AM',
      label: '-60 min',
      isForecast: false,
      rainIntensity: 'Moderate',
      dbz: 32.0,
      movementDirection: 'NE → SW',
      movementSpeedKmH: 22,
    ),
    RadarFrame(
      time: '11:30 AM',
      label: '-30 min',
      isForecast: false,
      rainIntensity: 'Moderate',
      dbz: 36.0,
      movementDirection: 'NE → SW',
      movementSpeedKmH: 24,
    ),
    RadarFrame(
      time: '12:00 PM',
      label: 'NOW',
      isForecast: false,
      rainIntensity: 'Heavy in core',
      dbz: 42.0,
      movementDirection: 'NE → SW',
      movementSpeedKmH: 25,
    ),
    RadarFrame(
      time: '12:30 PM',
      label: '+30 min',
      isForecast: true,
      rainIntensity: 'Moderate',
      dbz: 34.0,
      movementDirection: 'NE → SW',
      movementSpeedKmH: 24,
    ),
    RadarFrame(
      time: '01:00 PM',
      label: '+60 min',
      isForecast: true,
      rainIntensity: 'Light Scattered',
      dbz: 26.0,
      movementDirection: 'NE → SW',
      movementSpeedKmH: 22,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _sweepAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _sweepAnimController.dispose();
    _transController.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startPlaybackTimer();
      } else {
        _playbackTimer?.cancel();
      }
    });
  }

  void _startPlaybackTimer() {
    _playbackTimer?.cancel();
    _playbackTimer =
        Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (!mounted) return;
      setState(() {
        _currentFrameIndex = (_currentFrameIndex + 1) % _frames.length;
      });
    });
  }

  void _stepFrame(int step) {
    if (_isPlaying) {
      _togglePlayback();
    }
    setState(() {
      _currentFrameIndex =
          (_currentFrameIndex + step).clamp(0, _frames.length - 1);
    });
  }

  void _zoom(double factor) {
    final matrix = _transController.value.clone();
    matrix.scale(factor, factor);
    _transController.value = matrix;
  }

  void _resetLocation() {
    _transController.value = Matrix4.identity();
  }

  void _showInfoSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurfaceCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _RadarInfoSheet(isDark: isDark),
    );
  }

  void _showLayerPicker(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurfaceCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _RadarLayerPickerSheet(
        isDark: isDark,
        currentLayer: _selectedLayer,
        onSelect: (layer) {
          setState(() => _selectedLayer = layer);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showSevereAlert(String title, String message, String time) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurfaceCard,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.statusWarning, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textDarkSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.statusWarning.withOpacity(0.15),
                borderRadius: AppRadius.brSm,
              ),
              child: Text(
                'Detected at $time • Doppler Tracking Active',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.statusWarning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss',
                style: TextStyle(color: AppColors.accentCyan)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = ref.watch(locationProvider).selectedLocation;
    final currentFrame = _frames[_currentFrameIndex];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _selectedLayer.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: currentFrame.isForecast
                        ? AppColors.statusWarning.withOpacity(0.18)
                        : AppColors.accentCyan.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    currentFrame.isForecast ? 'NOWCAST' : 'LIVE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: currentFrame.isForecast
                          ? AppColors.statusWarning
                          : AppColors.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '${location.name}, ${location.state} • 250km Scan',
              style: AppTypography.labelSmall.copyWith(
                color:
                    isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers_rounded),
            tooltip: 'Radar Layers',
            onPressed: () => _showLayerPicker(context, isDark),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Radar Information',
            onPressed: () => _showInfoSheet(context, isDark),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Pan/Zoom Interactive Map Base and Doppler Radar Canvas
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transController,
              minScale: 0.6,
              maxScale: 3.5,
              boundaryMargin: const EdgeInsets.all(200),
              child: AnimatedBuilder(
                animation: _sweepAnimController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _AdvancedRadarMapPainter(
                      isDark: isDark,
                      layer: _selectedLayer,
                      sweepAngle: _sweepAnimController.value * 2 * pi,
                      frameProgress: _currentFrameIndex / (_frames.length - 1),
                      centerLocationName: location.name,
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Severe Storm Interactive Markers on Map
          Positioned(
            top: 140,
            left: 70,
            child: _SevereMarkerBadge(
              icon: Icons.bolt_rounded,
              label: 'Lightning Cell',
              color: const Color(0xFFFFB300),
              onTap: () => _showSevereAlert(
                'Severe Lightning Cluster',
                'Active cloud-to-ground lightning detected 14 km North-East of ${location.name}. Precipitation rate exceeding 35 mm/h.',
                currentFrame.time,
              ),
            ),
          ),
          Positioned(
            top: 260,
            right: 80,
            child: _SevereMarkerBadge(
              icon: Icons.warning_amber_rounded,
              label: 'Heavy Core 45 dBZ',
              color: AppColors.statusDanger,
              onTap: () => _showSevereAlert(
                'Heavy Convective Precipitation',
                'High reflectivity core detected approaching South-West corridor. Road visibility may be severely reduced.',
                currentFrame.time,
              ),
            ),
          ),

          // 3. Quick Layer Toggle Bar (Top Horizon)
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: RadarLayer.values.map((layer) {
                  final isSelected = layer == _selectedLayer;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: AppRadius.brPill,
                        onTap: () => setState(() => _selectedLayer = layer),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryBlue
                                : (isDark
                                    ? AppColors.darkSurfaceCard.withOpacity(0.9)
                                    : Colors.white.withOpacity(0.9)),
                            borderRadius: AppRadius.brPill,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                layer.icon,
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? AppColors.accentCyan
                                        : AppColors.primaryBlue),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                layer.label.split(' ').first,
                                style: AppTypography.labelSmall.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white
                                          : AppColors.textLightPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // 4. Map Viewport Controls (Zoom in / out / Center)
          Positioned(
            right: 16,
            top: 72,
            child: Column(
              children: [
                _MapControlButton(
                  icon: Icons.my_location_rounded,
                  tooltip: 'Center Location',
                  isDark: isDark,
                  onTap: _resetLocation,
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.add_rounded,
                  tooltip: 'Zoom In',
                  isDark: isDark,
                  onTap: () => _zoom(1.25),
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.remove_rounded,
                  tooltip: 'Zoom Out',
                  isDark: isDark,
                  onTap: () => _zoom(0.8),
                ),
              ],
            ),
          ),

          // 5. Bottom Interactive Timeline & Radar Status Panel
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard.withOpacity(0.96)
                    : AppColors.lightSurface.withOpacity(0.96),
                borderRadius: AppRadius.brXl,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Frame Header & Forecast Type Badge
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: currentFrame.isForecast
                            ? AppColors.statusWarning
                            : AppColors.accentCyan,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currentFrame.time,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : AppColors.textLightPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: currentFrame.isForecast
                                ? AppColors.statusWarning.withOpacity(0.18)
                                : AppColors.accentCyan.withOpacity(0.18),
                            borderRadius: AppRadius.brPill,
                          ),
                          child: Text(
                            currentFrame.isForecast
                                ? 'NOWCAST (${currentFrame.label})'
                                : 'OBSERVED (${currentFrame.label})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: currentFrame.isForecast
                                  ? AppColors.statusWarning
                                  : AppColors.accentCyan,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${currentFrame.dbz.toInt()} dBZ',
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Timeline Step Slider & Play/Pause Controls
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded, size: 24),
                        color: isDark
                            ? Colors.white70
                            : AppColors.textLightSecondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _stepFrame(-1),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_filled_rounded,
                          color: AppColors.accentCyan,
                          size: 38,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _togglePlayback,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, size: 24),
                        color: isDark
                            ? Colors.white70
                            : AppColors.textLightSecondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _stepFrame(1),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7),
                          ),
                          child: Slider(
                            value: _currentFrameIndex.toDouble(),
                            min: 0,
                            max: (_frames.length - 1).toDouble(),
                            divisions: _frames.length - 1,
                            activeColor: currentFrame.isForecast
                                ? AppColors.statusWarning
                                : AppColors.accentCyan,
                            inactiveColor: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                            onChanged: (val) {
                              if (_isPlaying) _togglePlayback();
                              setState(() => _currentFrameIndex = val.toInt());
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Timeline Labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _frames.asMap().entries.map((e) {
                        final isCur = e.key == _currentFrameIndex;
                        return Flexible(
                          child: Text(
                            e.value.label,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  isCur ? FontWeight.w800 : FontWeight.w500,
                              color: isCur
                                  ? (e.value.isForecast
                                      ? AppColors.statusWarning
                                      : AppColors.accentCyan)
                                  : (isDark
                                      ? AppColors.textDarkMuted
                                      : AppColors.textLightMuted),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Color Scale Intensity Legend
                  Row(
                    children: [
                      Text(
                        'Intensity:',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textDarkMuted
                              : AppColors.textLightMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Light',
                          style:
                              AppTypography.labelSmall.copyWith(fontSize: 10)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF00E5FF),
                                Color(0xFF00E676),
                                Color(0xFFFFEB3B),
                                Color(0xFFFF9800),
                                Color(0xFFFF1744),
                                Color(0xFFD500F9),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('Extreme',
                          style:
                              AppTypography.labelSmall.copyWith(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Current Weather Movement & Freshness Summary
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightBackgroundSecondary,
                      borderRadius: AppRadius.brSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.navigation_rounded,
                            size: 14, color: AppColors.accentCyan),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Movement: ${currentFrame.movementDirection} (${currentFrame.movementSpeedKmH} km/h) • ${currentFrame.rainIntensity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Demo Radar',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 9,
                            color: isDark
                                ? AppColors.textDarkMuted
                                : AppColors.textLightMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isDark;
  final VoidCallback onTap;

  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceCard.withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AppColors.accentCyan),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onTap,
      ),
    );
  }
}

class _SevereMarkerBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SevereMarkerBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.black87),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadarLayerPickerSheet extends StatelessWidget {
  final bool isDark;
  final RadarLayer currentLayer;
  final ValueChanged<RadarLayer> onSelect;

  const _RadarLayerPickerSheet({
    required this.isDark,
    required this.currentLayer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.layers_rounded, color: AppColors.accentCyan),
              const SizedBox(width: 10),
              Text(
                'Select Radar Layer',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textLightPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...RadarLayer.values.map((layer) {
            final isSelected = layer == currentLayer;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue.withOpacity(0.2)
                      : (isDark
                          ? AppColors.darkSurfaceElevated
                          : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  layer.icon,
                  color: isSelected
                      ? AppColors.accentCyan
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
              title: Text(
                layer.label,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.textLightPrimary,
                ),
              ),
              subtitle: Text(
                layer.subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textDarkMuted
                      : AppColors.textLightMuted,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.accentCyan)
                  : null,
              onTap: () => onSelect(layer),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _RadarInfoSheet extends StatelessWidget {
  final bool isDark;

  const _RadarInfoSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.accentCyan),
              const SizedBox(width: 10),
              Text(
                'How Weather Radar Works',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textLightPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '• Doppler Radar detects precipitation (rain, hail, snow) by emitting electromagnetic pulses and measuring return signals.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Colors represent Reflectivity (dBZ): Cyan/Green = Light Rain, Yellow/Orange = Moderate Rain, Red/Purple = Severe Thunderstorms & Hail.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Timeline: Frames marked [OBSERVED] represent recorded radar scans. Frames marked [NOWCAST] indicate high-resolution predictive storm motion vectors.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceElevated
                  : AppColors.lightBackgroundSecondary,
              borderRadius: AppRadius.brMd,
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined,
                    size: 18, color: AppColors.accentCyan),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Data Transparency: Synthetic Doppler simulation model for SIH prototype validation.',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark
                          ? AppColors.textDarkMuted
                          : AppColors.textLightMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AdvancedRadarMapPainter extends CustomPainter {
  final bool isDark;
  final RadarLayer layer;
  final double sweepAngle;
  final double frameProgress; // 0.0 to 1.0
  final String centerLocationName;

  _AdvancedRadarMapPainter({
    required this.isDark,
    required this.layer,
    required this.sweepAngle,
    required this.frameProgress,
    required this.centerLocationName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark Vector Map Base Background
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF090E1A) : const Color(0xFFD3DFEE);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final center = Offset(size.width / 2, size.height / 2);

    // 2. Geographic Road Grid and District Arteries
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF131D30) : const Color(0xFFB8CCE2)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 3. Meandering Gomti River Vector Path
    final riverPaint = Paint()
      ..color = isDark ? const Color(0xFF102540) : const Color(0xFF90BBE8)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final riverPath = Path();
    riverPath.moveTo(size.width * 0.1, size.height * 0.15);
    riverPath.cubicTo(
      size.width * 0.35,
      size.height * 0.35,
      size.width * 0.45,
      size.height * 0.60,
      size.width * 0.90,
      size.height * 0.85,
    );
    canvas.drawPath(riverPath, riverPaint);

    // 4. Concentric Radar Scan Distance Rings (50km, 100km, 150km, 200km)
    final ringPaint = Paint()
      ..color = isDark ? const Color(0xFF182844) : const Color(0xFFA5C3E3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final List<double> radii = [65.0, 130.0, 195.0, 260.0];
    final List<String> ringLabels = ['50 km', '100 km', '150 km', '200 km'];

    for (int i = 0; i < radii.length; i++) {
      final r = radii[i];
      canvas.drawCircle(center, r, ringPaint);

      // Distance Ring Label
      textPainter.text = TextSpan(
        text: ringLabels[i],
        style: TextStyle(
          color: isDark ? const Color(0xFF4A658A) : const Color(0xFF6E8EAF),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(center.dx + 4, center.dy - r - 12));
    }

    // 5. Doppler Rotating Beam Sweep & Phosphor Glow Trail
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: FractionalOffset.center,
        startAngle: sweepAngle - 0.5,
        endAngle: sweepAngle,
        colors: [
          Colors.transparent,
          AppColors.accentCyan.withOpacity(0.35),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 260));

    canvas.drawCircle(center, 260, sweepPaint);

    final sweepLineEnd = Offset(
      center.dx + cos(sweepAngle) * 260,
      center.dy + sin(sweepAngle) * 260,
    );
    final sweepLinePaint = Paint()
      ..color = AppColors.accentCyan.withOpacity(0.5)
      ..strokeWidth = 2.0;
    canvas.drawLine(center, sweepLineEnd, sweepLinePaint);

    // 6. Dynamic Layer Precipitation & Atmospheric Vectors
    final driftX = (frameProgress - 0.5) * 60;
    final driftY = (frameProgress - 0.5) * 45;

    if (layer == RadarLayer.rain || layer == RadarLayer.storm) {
      // Outermost Light Rain Isobar (Cyan-Green 20-30 dBZ)
      final rainOuterPaint = Paint()
        ..color = const Color(0x7700E5FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 32);
      canvas.drawCircle(
        Offset(center.dx - 30 + driftX, center.dy - 20 + driftY),
        85,
        rainOuterPaint,
      );

      // Moderate Rain Isobar (Green-Yellow 35-42 dBZ)
      final rainMidPaint = Paint()
        ..color = const Color(0x9900E676)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
      canvas.drawCircle(
        Offset(center.dx + 25 + driftX, center.dy + 15 + driftY),
        65,
        rainMidPaint,
      );

      // Heavy Precipitation Core (Orange-Red 48-55 dBZ)
      final rainCorePaint = Paint()
        ..color = const Color(0xCCFF9800)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
      canvas.drawCircle(
        Offset(center.dx + 15 + driftX, center.dy + 8 + driftY),
        42,
        rainCorePaint,
      );

      // Severe Convective / Hail Core (Magenta 60+ dBZ)
      final hailCorePaint = Paint()
        ..color = const Color(0xEEFF1744)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(
        Offset(center.dx + 10 + driftX, center.dy + 5 + driftY),
        22,
        hailCorePaint,
      );
    } else if (layer == RadarLayer.wind) {
      // Wind Streamline Vectors
      final windPaint = Paint()
        ..color = const Color(0xAA00E5FF)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (int i = -3; i <= 3; i++) {
        final path = Path();
        final startY = center.dy + (i * 45) + driftY;
        path.moveTo(center.dx - 180, startY - 30);
        path.quadraticBezierTo(
          center.dx,
          startY + 20,
          center.dx + 180,
          startY - 25,
        );
        canvas.drawPath(path, windPaint);
      }
    } else if (layer == RadarLayer.temperature) {
      // Thermal Heat-Island Contours
      final heatPaint = Paint()
        ..color = const Color(0x88FF5722)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
      canvas.drawCircle(Offset(center.dx, center.dy), 110, heatPaint);
    } else if (layer == RadarLayer.cloud) {
      // Infrared Satellite Cloud Cover
      final cloudPaint = Paint()
        ..color = const Color(0x88CFD8DC)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 36);
      canvas.drawCircle(
          Offset(center.dx - 40 + driftX, center.dy - 30 + driftY),
          100,
          cloudPaint);
      canvas.drawCircle(
          Offset(center.dx + 50 + driftX, center.dy + 40 + driftY),
          90,
          cloudPaint);
    }

    // 7. Surrounding Regional City Landmarks
    _drawCityPin(
        canvas, center.translate(-70, -110), 'Sitapur', '28°C', isDark);
    _drawCityPin(
        canvas, center.translate(110, -50), 'Barabanki', '29°C', isDark);
    _drawCityPin(canvas, center.translate(-110, 80), 'Kanpur', '31°C', isDark);
    _drawCityPin(canvas, center.translate(140, 70), 'Ayodhya', '29°C', isDark);
    _drawCityPin(
        canvas, center.translate(30, 140), 'Rae Bareli', '30°C', isDark);

    // 8. User Current Location Pin with Pulsing Ripple
    final pulsePaint = Paint()
      ..color = AppColors.accentCyan.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 22, pulsePaint);

    final locPinBg = Paint()..color = AppColors.primaryBlue;
    canvas.drawCircle(center, 9, locPinBg);

    final locPinDot = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, locPinDot);

    // Center Location Pin Title
    textPainter.text = TextSpan(
      text: centerLocationName,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        shadows: [
          Shadow(color: Colors.black, blurRadius: 6),
        ],
      ),
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(center.dx - (textPainter.width / 2), center.dy + 14));
  }

  void _drawCityPin(
      Canvas canvas, Offset offset, String name, String temp, bool isDark) {
    final dotPaint = Paint()
      ..color = isDark ? const Color(0xFF6E8EAF) : const Color(0xFF4A658A);
    canvas.drawCircle(offset, 4, dotPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: '$name ($temp)',
      style: TextStyle(
        color: isDark ? const Color(0xFF90A4AE) : const Color(0xFF37474F),
        fontSize: 9,
        fontWeight: FontWeight.w600,
        shadows: const [
          Shadow(color: Colors.black45, blurRadius: 4),
        ],
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx + 6, offset.dy - 6));
  }

  @override
  bool shouldRepaint(covariant _AdvancedRadarMapPainter oldDelegate) => true;
}
