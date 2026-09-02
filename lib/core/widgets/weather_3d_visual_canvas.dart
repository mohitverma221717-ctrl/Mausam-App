import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../features/weather/domain/models/weather_data.dart';

/// Performance profiles for adaptive rendering
enum PerformanceQuality { high, medium, low }

/// 3D Weather Visual Canvas Engine
/// Renders GPU-accelerated volumetric weather visual effects
class Weather3dVisualCanvas extends StatefulWidget {
  final WeatherConditionType conditionType;
  final PerformanceQuality quality;

  const Weather3dVisualCanvas({
    super.key,
    required this.conditionType,
    this.quality = PerformanceQuality.high,
  });

  @override
  State<Weather3dVisualCanvas> createState() => _Weather3dVisualCanvasState();
}

class _Weather3dVisualCanvasState extends State<Weather3dVisualCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final Random _random = Random(42);
  late List<_Particle> _particles;
  late List<_CloudLayer> _clouds;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _initParticles();
  }

  @override
  void didUpdateWidget(Weather3dVisualCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conditionType != widget.conditionType) {
      _initParticles();
    }
  }

  void _initParticles() {
    int particleCount = widget.quality == PerformanceQuality.high
        ? 60
        : (widget.quality == PerformanceQuality.medium ? 35 : 15);

    _particles = List.generate(particleCount, (i) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        z: _random.nextDouble() * 0.8 + 0.2, // Depth factor 0.2 to 1.0
        speed: _random.nextDouble() * 0.5 + 0.5,
        size: _random.nextDouble() * 4 + 2,
        opacity: _random.nextDouble() * 0.6 + 0.4,
      );
    });

    _clouds = List.generate(4, (i) {
      return _CloudLayer(
        xOffset: _random.nextDouble(),
        yRatio: 0.08 + i * 0.06,
        scale: 0.8 + i * 0.25,
        speed: 0.02 + i * 0.015,
        opacity: 0.15 + (i * 0.08),
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _Weather3dPainter(
            conditionType: widget.conditionType,
            progress: _animController.value,
            particles: _particles,
            clouds: _clouds,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double z;
  double speed;
  double size;
  double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.z,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class _CloudLayer {
  double xOffset;
  double yRatio;
  double scale;
  double speed;
  double opacity;

  _CloudLayer({
    required this.xOffset,
    required this.yRatio,
    required this.scale,
    required this.speed,
    required this.opacity,
  });
}

class _Weather3dPainter extends CustomPainter {
  final WeatherConditionType conditionType;
  final double progress;
  final List<_Particle> particles;
  final List<_CloudLayer> clouds;
  final bool isDark;

  _Weather3dPainter({
    required this.conditionType,
    required this.progress,
    required this.particles,
    required this.clouds,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (conditionType) {
      case WeatherConditionType.sunny:
        _draw3dSun(canvas, size);
        break;
      case WeatherConditionType.clearNight:
        _draw3dMoonAndStars(canvas, size);
        break;
      case WeatherConditionType.partlyCloudyNight:
        _draw3dMoonAndStars(canvas, size);
        _drawVolumetricClouds(canvas, size);
        break;
      case WeatherConditionType.partlyCloudy:
        _draw3dSun(canvas, size);
        _drawVolumetricClouds(canvas, size);
        break;
      case WeatherConditionType.cloudy:
        _drawVolumetricClouds(canvas, size);
        break;
      case WeatherConditionType.rainy:
        _draw3dRain(canvas, size, isHeavy: false);
        break;
      case WeatherConditionType.heavyRain:
        _draw3dRain(canvas, size, isHeavy: true);
        break;
      case WeatherConditionType.thunderstorm:
        _draw3dThunderstorm(canvas, size);
        break;
      case WeatherConditionType.foggy:
        _drawVolumetricFog(canvas, size);
        break;
      case WeatherConditionType.snowy:
        _draw3dSnow(canvas, size);
        break;
      case WeatherConditionType.windy:
        _drawWindStreamlines(canvas, size);
        break;
    }
  }

  // 1. 3D Realistic Sun with Volumetric Rays
  void _draw3dSun(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.78, size.height * 0.16);
    final sunRadius = min(size.width, size.height) * 0.14;

    // Volumetric Outer Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(

          colors: [
            const Color(0xFFFFB300).withOpacity(0.35),
            const Color(0xFFFF8F00).withOpacity(0.12),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: sunRadius * 2.8));
    canvas.drawCircle(center, sunRadius * 2.8, glowPaint);

    // Dynamic 3D Sun Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFFD54F).withOpacity(0.12)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const rayCount = 12;
    for (int i = 0; i < rayCount; i++) {
      double angle = (i * (2 * pi / rayCount)) + (progress * 2 * pi * 0.05);
      double rayLen = sunRadius * (1.3 + 0.2 * sin(progress * 2 * pi * 2 + i));
      Offset endPoint = Offset(
        center.dx + cos(angle) * rayLen,
        center.dy + sin(angle) * rayLen,
      );
      canvas.drawLine(center, endPoint, rayPaint);
    }

    // 3D Sun Sphere Shading
    final sunShader = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 0.85,
      colors: const [
        Color(0xFFFFF59D),
        Color(0xFFFFB300),
        Color(0xFFE65100),
      ],
      stops: const [0.1, 0.65, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: sunRadius));

    final sunPaint = Paint()..shader = sunShader;
    canvas.drawCircle(center, sunRadius, sunPaint);

    // Sun Dust Ambient Floating Particles
    for (var p in particles) {
      double py = (p.y + progress * p.speed * 0.2) % 1.0;
      double px = (p.x + sin(progress * 2 * pi + p.y * 10) * 0.02) % 1.0;
      final pos = Offset(px * size.width, py * size.height * 0.5);
      final pPaint = Paint()
        ..color = const Color(0xFFFFE082).withOpacity(p.opacity * 0.4 * p.z)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.z * 2);
      canvas.drawCircle(pos, p.size * p.z, pPaint);
    }
  }

  // 2. 3D Moon & Starfield
  void _draw3dMoonAndStars(Canvas canvas, Size size) {
    // Twinkling Stars
    for (var p in particles) {
      double alpha = (sin(progress * 2 * pi * 4 + p.x * 100) + 1) / 2;
      final pos = Offset(p.x * size.width, p.y * size.height * 0.55);
      final starPaint = Paint()
        ..color = Colors.white.withOpacity(alpha * 0.7 * p.opacity);
      canvas.drawCircle(pos, p.size * 0.6 * p.z, starPaint);
    }

    // 3D Crescent Moon
    final center = Offset(size.width * 0.76, size.height * 0.18);
    final moonRadius = min(size.width, size.height) * 0.12;

    // Moonlight Soft Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentCyan.withOpacity(0.2),
          const Color(0xFF1E293B).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: moonRadius * 2.4));
    canvas.drawCircle(center, moonRadius * 2.4, glowPaint);

    final moonPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1);
    canvas.drawCircle(center, moonRadius, moonPaint);

    // Shadow Overlay for 3D Crescent Effect
    final shadowOffset = Offset(center.dx - moonRadius * 0.45, center.dy - moonRadius * 0.2);
    final shadowPaint = Paint()
      ..color = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    canvas.drawCircle(shadowOffset, moonRadius * 0.92, shadowPaint);
  }

  // 3. Volumetric 3D Drifting Clouds
  void _drawVolumetricClouds(Canvas canvas, Size size) {
    for (var c in clouds) {
      double cx = ((c.xOffset + progress * c.speed) % 1.4) * size.width - (size.width * 0.2);
      double cy = size.height * c.yRatio;

      final cloudPaint = Paint()
        ..color = (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1))
            .withOpacity(c.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12 * c.scale);

      final r = 40.0 * c.scale;
      canvas.drawCircle(Offset(cx, cy), r * 1.1, cloudPaint);
      canvas.drawCircle(Offset(cx + r * 0.7, cy - r * 0.3), r * 0.9, cloudPaint);
      canvas.drawCircle(Offset(cx + r * 1.4, cy), r * 0.8, cloudPaint);
    }
  }

  // 4. Multi-Depth 3D Falling Rain
  void _draw3dRain(Canvas canvas, Size size, {bool isHeavy = false}) {
    _drawVolumetricClouds(canvas, size);

    if (isHeavy) {
      final mistPaint = Paint()
        ..color = (isDark ? const Color(0xFF1E293B) : const Color(0xFF94A3B8))
            .withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawRect(
          Rect.fromLTWH(0, size.height * 0.2, size.width, size.height * 0.6),
          mistPaint);
    }

    final speedMult = isHeavy ? 3.8 : 2.2;
    for (var p in particles) {
      double ry = (p.y + progress * p.speed * speedMult) % 1.0;
      double rx = (p.x + ry * 0.1) % 1.0;

      final start = Offset(rx * size.width, ry * size.height);
      final end = Offset(
          start.dx + (isHeavy ? 6 : 4) * p.z, start.dy + (isHeavy ? 24 : 18) * p.z);

      final rainPaint = Paint()
        ..color = (isDark ? AppColors.accentCyan : const Color(0xFF0284C7))
            .withOpacity(p.opacity * (isHeavy ? 0.8 : 0.6) * p.z)
        ..strokeWidth = (isHeavy ? 1.8 : 1.2) * p.z
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, rainPaint);
    }
  }

  // 5. Cinematic 3D Thunderstorm with Procedural Lightning
  void _draw3dThunderstorm(Canvas canvas, Size size) {
    _draw3dRain(canvas, size);

    // Random Lightning Flash (Brief burst every ~3.5 seconds)
    double flashCycle = (progress * 15) % 1.0;
    if (flashCycle > 0.92) {
      double alpha = sin((flashCycle - 0.92) / 0.08 * pi);

      // Sky Ambient Flash
      final flashPaint = Paint()
        ..color = Colors.white.withOpacity(alpha * 0.25);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), flashPaint);

      // Branching Lightning Bolt
      final boltPaint = Paint()
        ..color = Colors.white.withOpacity(alpha * 0.9)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke;

      final path = Path();
      double startX = size.width * 0.6;
      double startY = size.height * 0.05;
      path.moveTo(startX, startY);

      double curX = startX;
      double curY = startY;
      for (int i = 0; i < 6; i++) {
        curX += (sin(i * 1.5 + progress) * 24);
        curY += size.height * 0.06;
        path.lineTo(curX, curY);
      }
      canvas.drawPath(path, boltPaint);
    }
  }

  // 6. Volumetric Fog & Mist
  void _drawVolumetricFog(Canvas canvas, Size size) {
    for (int i = 0; i < 3; i++) {
      double fy = size.height * (0.15 + i * 0.1);
      double fx = sin(progress * 2 * pi * 0.5 + i) * 30;

      final fogPaint = Paint()
        ..color = (isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0))
            .withOpacity(0.25 - i * 0.05)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 24 + i * 8);

      canvas.drawRect(
        Rect.fromLTWH(fx - 40, fy, size.width + 80, 70),
        fogPaint,
      );
    }
  }

  // 7. 3D Swaying Snowflakes
  void _draw3dSnow(Canvas canvas, Size size) {
    for (var p in particles) {
      double sy = (p.y + progress * p.speed * 0.4) % 1.0;
      double sx = (p.x + sin(progress * 2 * pi * 2 + p.y * 5) * 0.04) % 1.0;

      final pos = Offset(sx * size.width, sy * size.height);
      final snowPaint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * 0.8 * p.z)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.z);

      canvas.drawCircle(pos, p.size * 0.8 * p.z, snowPaint);
    }
  }

  // 8. Aerodynamic Wind Streamlines
  void _drawWindStreamlines(Canvas canvas, Size size) {
    final windPaint = Paint()
      ..color = (isDark ? AppColors.accentCyan : const Color(0xFF0284C7))
          .withOpacity(0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      double wx = ((progress * 1.5 + i * 0.2) % 1.2) * size.width - 60;
      double wy = size.height * (0.1 + i * 0.08);

      final path = Path();
      path.moveTo(wx, wy);
      path.quadraticBezierTo(wx + 40, wy - 10, wx + 80, wy);
      canvas.drawPath(path, windPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _Weather3dPainter oldDelegate) => true;
}
