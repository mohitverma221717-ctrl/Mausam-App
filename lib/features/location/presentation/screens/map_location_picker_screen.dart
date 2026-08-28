import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../domain/models/location_model.dart';
import '../providers/location_provider.dart';

class MapLocationPickerScreen extends ConsumerStatefulWidget {
  const MapLocationPickerScreen({super.key});

  @override
  ConsumerState<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState
    extends ConsumerState<MapLocationPickerScreen> {
  LocationModel _pinnedLocation = const LocationModel(
    id: 'loc-map-pin',
    name: 'Lucknow',
    state: 'Uttar Pradesh',
    country: 'India',
    lat: 26.8467,
    lon: 80.9462,
    currentTemp: 29.0,
    currentCondition: 'Partly Cloudy',
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Map Location Picker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Simulated Radar/Vector Map Surface
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF09111E) : const Color(0xFFE2EAF4),
            ),
            child: CustomPaint(
              painter: _MapGridPainter(isDark: isDark),
            ),
          ),

          // Center Pin
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkSurfaceElevated : Colors.white,
                    borderRadius: AppRadius.brMd,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: AppColors.primaryBlue),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.place_rounded,
                          color: AppColors.statusDanger, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${_pinnedLocation.name}, ${_pinnedLocation.state}',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : AppColors.textLightPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.location_searching_rounded,
                  size: 40,
                  color: AppColors.accentCyan,
                ),
              ],
            ),
          ),

          // Map Action Buttons (GPS, Layers, Zoom)
          Positioned(
            right: 16,
            top: 20,
            child: Column(
              children: [
                _MapControlButton(
                  icon: Icons.my_location_rounded,
                  onTap: () {
                    setState(() {
                      _pinnedLocation = const LocationModel(
                        id: 'loc-map-pin',
                        name: 'Lucknow',
                        state: 'Uttar Pradesh',
                        country: 'India',
                        lat: 26.8467,
                        lon: 80.9462,
                        currentTemp: 29.0,
                        currentCondition: 'Partly Cloudy',
                      );
                    });
                  },
                ),
                const SizedBox(height: 10),
                _MapControlButton(
                  icon: Icons.layers_outlined,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _MapControlButton(
                  icon: Icons.add_rounded,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _MapControlButton(
                  icon: Icons.remove_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Bottom Confirmation Card
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.darkSurfaceCard : AppColors.lightSurface,
                borderRadius: AppRadius.brXl,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.accentCyan,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _pinnedLocation.name,
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textDarkPrimary
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            Text(
                              _pinnedLocation.fullAddress,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textDarkMuted
                                    : AppColors.textLightMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '29°C',
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  MausamButton(
                    text: 'Confirm Location',
                    width: double.infinity,
                    onPressed: () {
                      ref
                          .read(locationProvider.notifier)
                          .selectLocation(_pinnedLocation);
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/personalization/interests');
                      }
                    },
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
  final VoidCallback onTap;

  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: AppColors.accentCyan),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;

  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF16253E) : const Color(0xFFC7D7EC)
      ..strokeWidth = 1.0;

    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF1E3253) : const Color(0xFFB5CDE8)
      ..strokeWidth = 3.0;

    // Draw coordinate grid
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw stylized highway curves
    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width,
      size.height * 0.7,
    );
    canvas.drawPath(path, roadPaint);

    final path2 = Path();
    path2.moveTo(size.width * 0.3, 0);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.6,
      size.width * 0.8,
      size.height,
    );
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
