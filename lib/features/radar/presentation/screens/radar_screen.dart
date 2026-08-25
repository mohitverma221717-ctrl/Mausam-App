import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../location/presentation/providers/location_provider.dart';

enum RadarLayer { rain, cloud, wind, temperature }

class RadarScreen extends ConsumerStatefulWidget {
  const RadarScreen({super.key});

  @override
  ConsumerState<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends ConsumerState<RadarScreen>
    with SingleTickerProviderStateMixin {
  RadarLayer _selectedLayer = RadarLayer.rain;
  bool _isPlaying = true;
  double _timelineValue = 0.6; // 0.0 to 1.0 (e.g. 10:30 AM to 11:30 AM)
  late AnimationController _radarAnimController;

  @override
  void initState() {
    super.initState();
    _radarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = ref.watch(locationProvider).selectedLocation;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          _selectedLayer == RadarLayer.rain
              ? 'Rain Radar'
              : (_selectedLayer == RadarLayer.cloud
                  ? 'Cloud Map'
                  : (_selectedLayer == RadarLayer.wind
                      ? 'Wind Stream'
                      : 'Temperature Map')),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Radar Info',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Doppler Radar composite simulation • Data updated 5m ago'),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Interactive Animated Canvas Radar
          AnimatedBuilder(
            animation: _radarAnimController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _RadarCanvasPainter(
                  isDark: isDark,
                  layer: _selectedLayer,
                  animProgress: _radarAnimController.value,
                  timeline: _timelineValue,
                ),
              );
            },
          ),

          // Layer Selector Filter Chips (Top)
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _RadarLayerChip(
                    label: 'Rain Radar',
                    icon: Icons.grain_rounded,
                    isSelected: _selectedLayer == RadarLayer.rain,
                    onTap: () =>
                        setState(() => _selectedLayer = RadarLayer.rain),
                  ),
                  const SizedBox(width: 8),
                  _RadarLayerChip(
                    label: 'Clouds',
                    icon: Icons.cloud_rounded,
                    isSelected: _selectedLayer == RadarLayer.cloud,
                    onTap: () =>
                        setState(() => _selectedLayer = RadarLayer.cloud),
                  ),
                  const SizedBox(width: 8),
                  _RadarLayerChip(
                    label: 'Wind',
                    icon: Icons.air_rounded,
                    isSelected: _selectedLayer == RadarLayer.wind,
                    onTap: () =>
                        setState(() => _selectedLayer = RadarLayer.wind),
                  ),
                  const SizedBox(width: 8),
                  _RadarLayerChip(
                    label: 'Temperature',
                    icon: Icons.thermostat_rounded,
                    isSelected: _selectedLayer == RadarLayer.temperature,
                    onTap: () =>
                        setState(() => _selectedLayer = RadarLayer.temperature),
                  ),
                ],
              ),
            ),
          ),

          // Pinned City Label in Center
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                borderRadius: AppRadius.brPill,
                border: Border.all(color: AppColors.primaryBlue),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.my_location_rounded,
                      size: 14, color: AppColors.accentCyan),
                  const SizedBox(width: 6),
                  Text(
                    location.name,
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textLightPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map Zoom & Center Controls
          Positioned(
            right: 16,
            top: 70,
            child: Column(
              children: [
                _ControlIcon(
                  icon: Icons.my_location_rounded,
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _ControlIcon(
                  icon: Icons.add_rounded,
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _ControlIcon(
                  icon: Icons.remove_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Bottom Timeline Scrubber & Color Legend
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard.withOpacity(0.95)
                    : AppColors.lightSurface.withOpacity(0.95),
                borderRadius: AppRadius.brXl,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Play/Pause & Timeline Scrubber
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_filled_rounded,
                          color: AppColors.accentCyan,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                            if (_isPlaying) {
                              _radarAnimController.repeat();
                            } else {
                              _radarAnimController.stop();
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Slider(
                          value: _timelineValue,
                          activeColor: AppColors.accentCyan,
                          inactiveColor: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                          onChanged: (val) {
                            setState(() {
                              _timelineValue = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10:30 AM', style: AppTypography.labelSmall),
                        Text('NOW (11:05 AM)',
                            style: AppTypography.labelSmall.copyWith(
                                color: AppColors.accentCyan,
                                fontWeight: FontWeight.w700)),
                        Text('11:30 AM', style: AppTypography.labelSmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Color Scale Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Light',
                          style:
                              AppTypography.labelSmall.copyWith(fontSize: 10)),
                      Container(
                        width: 180,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00E5FF),
                              Color(0xFF00E676),
                              Color(0xFFFFB300),
                              Color(0xFFFF3D71),
                              Color(0xFFD500F9),
                            ],
                          ),
                        ),
                      ),
                      Text('Heavy',
                          style:
                              AppTypography.labelSmall.copyWith(fontSize: 10)),
                    ],
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

class _RadarLayerChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadarLayerChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.brPill,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue
                : (isDark
                    ? AppColors.darkSurfaceElevated.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9)),
            borderRadius: AppRadius.brPill,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryBlue
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.accentCyan : AppColors.primaryBlue),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white : AppColors.textLightPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated.withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AppColors.accentCyan),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _RadarCanvasPainter extends CustomPainter {
  final bool isDark;
  final RadarLayer layer;
  final double animProgress;
  final double timeline;

  _RadarCanvasPainter({
    required this.isDark,
    required this.layer,
    required this.animProgress,
    required this.timeline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF080D1A) : const Color(0xFFD6E3F2);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final center = Offset(size.width / 2, size.height / 2);

    // Draw Map concentric distance rings
    final ringPaint = Paint()
      ..color = isDark ? const Color(0xFF152238) : const Color(0xFFB0C8E3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double r = 60; r < size.width * 0.9; r += 70) {
      canvas.drawCircle(center, r, ringPaint);
    }

    // Draw rotating radar sweep line
    final sweepAngle = animProgress * 2 * pi;
    final sweepEnd = Offset(
      center.dx + cos(sweepAngle) * size.width * 0.8,
      center.dy + sin(sweepAngle) * size.width * 0.8,
    );

    final sweepPaint = Paint()
      ..color = AppColors.accentCyan.withOpacity(0.25)
      ..strokeWidth = 2.0;
    canvas.drawLine(center, sweepEnd, sweepPaint);

    // Draw Simulated Radar Weather Isobar Blobs
    final cellPaint1 = Paint()
      ..color = const Color(0x9900E676) // Green
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
    canvas.drawCircle(Offset(center.dx - 40 + (timeline * 20), center.dy - 30),
        80, cellPaint1);

    final cellPaint2 = Paint()
      ..color = const Color(0xAAFFB300) // Orange/Yellow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawCircle(Offset(center.dx + 20, center.dy + 10), 55, cellPaint2);

    final cellPaint3 = Paint()
      ..color = const Color(0xCCFF3D71) // Red/Magenta core
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(Offset(center.dx + 10, center.dy), 32, cellPaint3);
  }

  @override
  bool shouldRepaint(covariant _RadarCanvasPainter oldDelegate) => true;
}
