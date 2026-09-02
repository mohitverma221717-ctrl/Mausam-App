import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/earth/domain/models/earth_layer_model.dart';

class EarthGlobeMarker {
  final String id;
  final String title;
  final String subtitle;
  final double lat;
  final double lon;
  final IconData icon;
  final Color color;

  const EarthGlobeMarker({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lat,
    required this.lon,
    required this.icon,
    required this.color,
  });
}

class EarthGlobeCanvas extends StatefulWidget {
  final bool is3DView;
  final EarthLayerType selectedLayer;
  final int hourOffset;
  final double zoomLevel;
  final Offset panOffset;
  final double yawAngle;
  final double pitchAngle;
  final List<EarthGlobeMarker> markers;
  final ValueChanged<Offset>? onPanUpdate;
  final ValueChanged<double>? onZoomChanged;
  final ValueChanged<EarthGlobeMarker>? onMarkerTap;

  const EarthGlobeCanvas({
    super.key,
    required this.is3DView,
    required this.selectedLayer,
    required this.hourOffset,
    required this.zoomLevel,
    required this.panOffset,
    required this.yawAngle,
    required this.pitchAngle,
    this.markers = const [],
    this.onPanUpdate,
    this.onZoomChanged,
    this.onMarkerTap,
  });

  @override
  State<EarthGlobeCanvas> createState() => _EarthGlobeCanvasState();
}

class _EarthGlobeCanvasState extends State<EarthGlobeCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _baseZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details, Size canvasSize) {
    if (widget.onMarkerTap == null) return;

    final center = Offset(
      canvasSize.width / 2 + widget.panOffset.dx,
      canvasSize.height / 2 + widget.panOffset.dy,
    );
    final radius = math.min(canvasSize.width, canvasSize.height) * 0.38 * widget.zoomLevel;
    final tapPos = details.localPosition;

    // Check hit on existing markers first
    EarthGlobeMarker? hitMarker;
    double closestDistance = double.infinity;

    for (final marker in widget.markers) {
      final pos = _calculateMarkerScreenPosition(marker, center, radius);
      if (pos != null) {
        final dist = (pos - tapPos).distance;
        if (dist < 28.0 && dist < closestDistance) {
          closestDistance = dist;
          hitMarker = marker;
        }
      }
    }

    if (hitMarker != null) {
      widget.onMarkerTap!(hitMarker);
      return;
    }

    // If tapped inside globe / map, create dynamic point telemetry marker
    if (widget.is3DView) {
      final dx = tapPos.dx - center.dx;
      final dy = tapPos.dy - center.dy;
      final distFromCenter = math.sqrt(dx * dx + dy * dy);

      if (distFromCenter <= radius) {
        final nx = dx / radius;
        final ny = -dy / radius;
        final nz = math.sqrt(math.max(0.0, 1.0 - nx * nx - ny * ny));

        final lat = (math.asin(ny) * 180 / math.pi) + (widget.pitchAngle * 180 / math.pi);
        final lon = (math.atan2(nx, nz) * 180 / math.pi) + (widget.yawAngle * 180 / math.pi);

        final clampedLat = lat.clamp(-90.0, 90.0);
        final normalizedLon = ((lon + 180) % 360) - 180;

        final dynamicMarker = EarthGlobeMarker(
          id: 'tap-${tapPos.dx.toInt()}-${tapPos.dy.toInt()}',
          title: 'Custom Telemetry Point',
          subtitle: 'Lat: ${clampedLat.toStringAsFixed(2)}°, Lon: ${normalizedLon.toStringAsFixed(2)}°',
          lat: clampedLat,
          lon: normalizedLon,
          icon: Icons.place_rounded,
          color: widget.selectedLayer.accentColor,
        );

        widget.onMarkerTap!(dynamicMarker);
      }
    } else {
      final mapWidth = radius * 2.2;
      final mapHeight = radius * 1.4;
      final mapRect = Rect.fromCenter(center: center, width: mapWidth, height: mapHeight);

      if (mapRect.contains(tapPos)) {
        final relX = (tapPos.dx - center.dx) / (mapWidth / 2);
        final relY = (center.dy - tapPos.dy) / (mapHeight / 2);

        final lon = (relX * 180).clamp(-180.0, 180.0);
        final lat = (relY * 90).clamp(-90.0, 90.0);

        final dynamicMarker = EarthGlobeMarker(
          id: 'tap-2d-${tapPos.dx.toInt()}',
          title: 'Selected Coordinate',
          subtitle: 'Lat: ${lat.toStringAsFixed(2)}°, Lon: ${lon.toStringAsFixed(2)}°',
          lat: lat,
          lon: lon,
          icon: Icons.place_rounded,
          color: widget.selectedLayer.accentColor,
        );

        widget.onMarkerTap!(dynamicMarker);
      }
    }
  }

  Offset? _calculateMarkerScreenPosition(EarthGlobeMarker marker, Offset center, double radius) {
    if (widget.is3DView) {
      final deltaLon = (marker.lon * math.pi / 180.0) - widget.yawAngle;
      final deltaLat = (marker.lat * math.pi / 180.0) - widget.pitchAngle;

      final z = radius * math.cos(deltaLat) * math.cos(deltaLon);
      if (z < -0.2 * radius) return null; // Behind hemisphere

      final x = center.dx + radius * math.cos(deltaLat) * math.sin(deltaLon);
      final y = center.dy - radius * math.sin(deltaLat);
      return Offset(x, y);
    } else {
      final mapWidth = radius * 2.2;
      final mapHeight = radius * 1.4;
      final x = center.dx + (marker.lon / 180.0) * (mapWidth / 2.0);
      final y = center.dy - (marker.lat / 90.0) * (mapHeight / 2.0);
      return Offset(x, y);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (details) {
            _baseZoom = widget.zoomLevel;
          },
          onScaleUpdate: (details) {
            if (details.pointerCount >= 2 || details.scale != 1.0) {
              if (widget.onZoomChanged != null) {
                final newZoom = (_baseZoom * details.scale).clamp(0.5, 3.0);
                widget.onZoomChanged!(newZoom);
              }
            } else if (widget.onPanUpdate != null) {
              widget.onPanUpdate!(details.focalPointDelta);
            }
          },
          onTapUp: (details) => _handleTap(details, canvasSize),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _EarthPainter(
                  is3DView: widget.is3DView,
                  selectedLayer: widget.selectedLayer,
                  hourOffset: widget.hourOffset,
                  zoomLevel: widget.zoomLevel,
                  panOffset: widget.panOffset,
                  yawAngle: widget.yawAngle,
                  pitchAngle: widget.pitchAngle,
                  animValue: _animationController.value,
                  markers: widget.markers,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _EarthPainter extends CustomPainter {
  final bool is3DView;
  final EarthLayerType selectedLayer;
  final int hourOffset;
  final double zoomLevel;
  final Offset panOffset;
  final double yawAngle;
  final double pitchAngle;
  final double animValue;
  final List<EarthGlobeMarker> markers;

  _EarthPainter({
    required this.is3DView,
    required this.selectedLayer,
    required this.hourOffset,
    required this.zoomLevel,
    required this.panOffset,
    required this.yawAngle,
    required this.pitchAngle,
    required this.animValue,
    required this.markers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 + panOffset.dx, size.height / 2 + panOffset.dy);
    final radius = math.min(size.width, size.height) * 0.38 * zoomLevel;

    // Outer Space Background
    final bgPaint = Paint()..color = const Color(0xFF030712);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Render Stars
    _drawStars(canvas, size);

    if (is3DView) {
      _draw3DGlobe(canvas, center, radius);
    } else {
      _draw2DMap(canvas, size, center, radius);
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white.withOpacity(0.5);
    final rand = math.Random(42);
    for (int i = 0; i < 65; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final r = (rand.nextDouble() * 1.5) + 0.5;
      final opacity = 0.25 + 0.7 * math.sin(animValue * 2 * math.pi + i);
      starPaint.color = Colors.white.withOpacity(opacity.clamp(0.15, 0.9));
      canvas.drawCircle(Offset(x, y), r, starPaint);
    }
  }

  void _draw3DGlobe(Canvas canvas, Offset center, double radius) {
    // 1. Atmosphere Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          selectedLayer.accentColor.withOpacity(0.4),
          selectedLayer.accentColor.withOpacity(0.12),
          Colors.transparent,
        ],
        stops: const [0.85, 0.96, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.25));
    canvas.drawCircle(center, radius * 1.25, glowPaint);

    // 2. Base Ocean Sphere Gradient
    final oceanShader = const RadialGradient(
      center: Alignment(-0.3, -0.4),
      colors: [
        Color(0xFF0284C7),
        Color(0xFF0F172A),
        Color(0xFF020617),
      ],
      stops: [0.0, 0.7, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    final oceanPaint = Paint()..shader = oceanShader;
    canvas.drawCircle(center, radius, oceanPaint);

    // Clip to Sphere for internal layers
    canvas.save();
    final spherePath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(spherePath);

    // 3. Grid Lines
    _drawGlobeGrid(canvas, center, radius);

    // 4. Continents Simulation
    _drawContinents3D(canvas, center, radius);

    // 5. Dynamic Weather Layer
    _drawWeatherLayer3D(canvas, center, radius);

    // 6. Day / Night Terminator Shading
    _drawTerminator3D(canvas, center, radius);

    // 7. Interactive Markers
    _drawMarkers3D(canvas, center, radius);

    canvas.restore();

    // Outer Sphere Border Highlight
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = selectedLayer.accentColor.withOpacity(0.6);
    canvas.drawCircle(center, radius, borderPaint);
  }

  void _drawGlobeGrid(Canvas canvas, Offset center, double radius) {
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = AppColors.cyanAccent.withOpacity(0.12);

    // Latitudes
    for (int i = -3; i <= 3; i++) {
      final y = center.dy + (i * radius / 4);
      final dy = (y - center.dy).abs();
      if (dy < radius) {
        final rx = math.sqrt(radius * radius - dy * dy);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(center.dx, y), width: rx * 2, height: radius * 0.25),
          gridPaint,
        );
      }
    }

    // Longitudes
    for (int i = -4; i <= 4; i++) {
      final xOffset = i * radius / 4;
      final rot = yawAngle + (i * math.pi / 4);
      final rx = radius * math.cos(rot).abs();
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx + xOffset * 0.3, center.dy), width: rx * 0.8, height: radius * 2),
        gridPaint,
      );
    }
  }

  void _drawContinents3D(Canvas canvas, Offset center, double radius) {
    final landPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.cyanAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    final rotX = center.dx + math.sin(yawAngle) * radius * 0.2;
    final rotY = center.dy + math.sin(pitchAngle) * radius * 0.2;

    path.moveTo(rotX - radius * 0.2, rotY - radius * 0.4);
    path.quadraticBezierTo(rotX, rotY - radius * 0.5, rotX + radius * 0.25, rotY - radius * 0.3);
    path.quadraticBezierTo(rotX + radius * 0.3, rotY + radius * 0.1, rotX + radius * 0.05, rotY + radius * 0.4);
    path.quadraticBezierTo(rotX - radius * 0.1, rotY + radius * 0.15, rotX - radius * 0.25, rotY - radius * 0.1);
    path.close();

    canvas.drawPath(path, landPaint);
    canvas.drawPath(path, borderPaint);
  }

  void _drawWeatherLayer3D(Canvas canvas, Offset center, double radius) {
    final layerColor = selectedLayer.accentColor;

    switch (selectedLayer) {
      case EarthLayerType.temperature:
        final tempPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.red.withOpacity(0.45),
              Colors.orange.withOpacity(0.35),
              Colors.blue.withOpacity(0.2),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius * 0.9));
        canvas.drawCircle(center, radius * 0.9, tempPaint);
        break;

      case EarthLayerType.precipitation:
      case EarthLayerType.clouds:
        final cloudPaint = Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
        final t = animValue * 2 * math.pi;
        canvas.drawCircle(Offset(center.dx + math.cos(t) * 25, center.dy + math.sin(t) * 18), radius * 0.55, cloudPaint);
        canvas.drawCircle(Offset(center.dx - 35, center.dy + 25), radius * 0.45, cloudPaint);
        break;

      case EarthLayerType.wind:
        final windPaint = Paint()
          ..color = AppColors.cyanAccent.withOpacity(0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        for (int i = 0; i < 5; i++) {
          final startY = center.dy - radius * 0.5 + (i * 35);
          final path = Path();
          path.moveTo(center.dx - radius * 0.7, startY);
          path.cubicTo(
            center.dx - radius * 0.2, startY - 20 + math.sin(animValue * 6 + i) * 10,
            center.dx + radius * 0.2, startY + 20 + math.cos(animValue * 6 + i) * 10,
            center.dx + radius * 0.7, startY,
          );
          canvas.drawPath(path, windPaint);
        }
        break;

      default:
        final generalPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              layerColor.withOpacity(0.5),
              layerColor.withOpacity(0.2),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius * 0.85));
        canvas.drawCircle(center, radius * 0.85, generalPaint);
        break;
    }
  }

  void _drawTerminator3D(Canvas canvas, Offset center, double radius) {
    final sunAngle = (hourOffset * (2 * math.pi / 24)) + (animValue * 0.2);
    final shadowDx = math.cos(sunAngle) * radius * 0.8;

    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black.withOpacity(0.68),
          Colors.black.withOpacity(0.22),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(center.dx - radius, center.dy - radius, radius * 2, radius * 2));

    canvas.drawCircle(Offset(center.dx + shadowDx * 0.2, center.dy), radius, shadowPaint);
  }

  void _drawMarkers3D(Canvas canvas, Offset center, double radius) {
    for (final marker in markers) {
      final deltaLon = (marker.lon * math.pi / 180.0) - yawAngle;
      final deltaLat = (marker.lat * math.pi / 180.0) - pitchAngle;

      final z = radius * math.cos(deltaLat) * math.cos(deltaLon);
      if (z < -0.2 * radius) continue;

      final markerX = center.dx + radius * math.cos(deltaLat) * math.sin(deltaLon);
      final markerY = center.dy - radius * math.sin(deltaLat);

      if (marker.id == 'marker-user' || marker.id.startsWith('marker-user')) {
        final pulseR = 8.0 + 8.0 * math.sin(animValue * 4 * math.pi);
        final pulsePaint = Paint()
          ..color = AppColors.cyanAccent.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(Offset(markerX, markerY), pulseR, pulsePaint);
      }

      final pinPaint = Paint()..color = marker.color;
      canvas.drawCircle(Offset(markerX, markerY), 6.5, pinPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: marker.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(markerX + 8, markerY - 6));
    }
  }

  void _draw2DMap(Canvas canvas, Size size, Offset center, double radius) {
    final mapWidth = radius * 2.2;
    final mapHeight = radius * 1.4;
    final mapRect = Rect.fromCenter(center: center, width: mapWidth, height: mapHeight);

    final mapBg = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(mapRect, mapBg);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = selectedLayer.accentColor.withOpacity(0.5);
    canvas.drawRect(mapRect, borderPaint);

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = AppColors.cyanAccent.withOpacity(0.15);

    for (int i = 1; i <= 4; i++) {
      final x = mapRect.left + (mapWidth / 5) * i;
      canvas.drawLine(Offset(x, mapRect.top), Offset(x, mapRect.bottom), gridPaint);
    }
    for (int i = 1; i <= 3; i++) {
      final y = mapRect.top + (mapHeight / 4) * i;
      canvas.drawLine(Offset(mapRect.left, y), Offset(mapRect.right, y), gridPaint);
    }

    _drawWeatherLayer3D(canvas, center, radius * 0.7);

    for (final marker in markers) {
      final markerX = center.dx + (marker.lon / 180.0) * (mapWidth / 2.0);
      final markerY = center.dy - (marker.lat / 90.0) * (mapHeight / 2.0);

      if (mapRect.contains(Offset(markerX, markerY))) {
        final pinPaint = Paint()..color = marker.color;
        canvas.drawCircle(Offset(markerX, markerY), 5.5, pinPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EarthPainter oldDelegate) {
    return oldDelegate.is3DView != is3DView ||
        oldDelegate.selectedLayer != selectedLayer ||
        oldDelegate.hourOffset != hourOffset ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.yawAngle != yawAngle ||
        oldDelegate.pitchAngle != pitchAngle ||
        oldDelegate.animValue != animValue ||
        oldDelegate.markers != markers;
  }
}
