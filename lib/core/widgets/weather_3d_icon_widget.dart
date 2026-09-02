import 'dart:math';
import 'package:flutter/material.dart';
import '../../features/weather/domain/models/weather_data.dart';

/// 3D Animated Weather Visual Icon / Graphic
/// Renders high-fidelity, volumetric 3D weather elements (Sun, Cloud, Rain, Storm, Snow, Night)
/// with real-time dynamic shading, glowing rays, rain drop physics, lightning flashes, and depth floating.
class Weather3dIconWidget extends StatefulWidget {
  final WeatherConditionType conditionType;
  final double size;
  final bool animate;
  final VoidCallback? onTap;

  const Weather3dIconWidget({
    super.key,
    required this.conditionType,
    this.size = 80.0,
    this.animate = true,
    this.onTap,
  });

  @override
  State<Weather3dIconWidget> createState() => _Weather3dIconWidgetState();
}

class _Weather3dIconWidgetState extends State<Weather3dIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final Random _random = Random(1337);
  late List<_IconParticle> _particles;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    if (widget.animate) {
      _animController.repeat();
    }

    _generateParticles();
  }

  @override
  void didUpdateWidget(Weather3dIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conditionType != widget.conditionType) {
      _generateParticles();
    }
    if (widget.animate && !_animController.isAnimating) {
      _animController.repeat();
    } else if (!widget.animate && _animController.isAnimating) {
      _animController.stop();
    }
  }

  void _generateParticles() {
    _particles = List.generate(24, (index) {
      return _IconParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        z: _random.nextDouble() * 0.8 + 0.2,
        speed: _random.nextDouble() * 0.6 + 0.4,
        size: _random.nextDouble() * 3 + 1.5,
        opacity: _random.nextDouble() * 0.7 + 0.3,
        angle: _random.nextDouble() * pi * 2,
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
    final widgetBody = AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        // Floating 3D Bobbing Motion
        final floatOffset = widget.animate
            ? sin(_animController.value * pi * 2) * (widget.size * 0.035)
            : 0.0;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _Weather3dIconPainter(
              conditionType: widget.conditionType,
              progress: _animController.value,
              particles: _particles,
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        );
      },
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: widgetBody,
      );
    }

    return widgetBody;
  }
}

class _IconParticle {
  double x;
  double y;
  double z;
  double speed;
  double size;
  double opacity;
  double angle;

  _IconParticle({
    required this.x,
    required this.y,
    required this.z,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.angle,
  });
}

class _Weather3dIconPainter extends CustomPainter {
  final WeatherConditionType conditionType;
  final double progress;
  final List<_IconParticle> particles;
  final bool isDark;

  _Weather3dIconPainter({
    required this.conditionType,
    required this.progress,
    required this.particles,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final minDim = min(size.width, size.height);

    switch (conditionType) {
      case WeatherConditionType.sunny:
        _draw3dSun(canvas, center, minDim);
        break;
      case WeatherConditionType.partlyCloudy:
        _draw3dPartlyCloudy(canvas, center, minDim);
        break;
      case WeatherConditionType.cloudy:
        _draw3dCloud(canvas, center, minDim);
        break;
      case WeatherConditionType.rainy:
      case WeatherConditionType.heavyRain:
        _draw3dRain(canvas, center, minDim, isHeavy: conditionType == WeatherConditionType.heavyRain);
        break;
      case WeatherConditionType.thunderstorm:
        _draw3dStorm(canvas, center, minDim);
        break;
      case WeatherConditionType.clearNight:
        _draw3dMoon(canvas, center, minDim);
        break;
      case WeatherConditionType.partlyCloudyNight:
        _draw3dPartlyCloudyNight(canvas, center, minDim);
        break;
      case WeatherConditionType.snowy:
        _draw3dSnow(canvas, center, minDim);
        break;
      case WeatherConditionType.foggy:
        _draw3dFog(canvas, center, minDim);
        break;
      case WeatherConditionType.windy:
        _draw3dWind(canvas, center, minDim);
        break;
    }
  }

  // --- 1. 3D SUN ANIMATION ---
  void _draw3dSun(Canvas canvas, Offset center, double dim) {
    final radius = dim * 0.28;

    // Glowing Ambient Aura
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFB300).withOpacity(0.4),
          const Color(0xFFFF8F00).withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 2.2));
    canvas.drawCircle(center, radius * 2.2, auraPaint);

    // Dynamic Rotating 3D Sun Rays with Depth Shading
    const rayCount = 12;
    final rayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < rayCount; i++) {
      final rayAngle = (i * (2 * pi / rayCount)) + (progress * 2 * pi * 0.25);
      final rayPulse = sin(progress * 2 * pi * 2 + i) * 0.15 + 1.0;
      final startDist = radius * 1.25;
      final endDist = radius * (1.65 * rayPulse);

      final p1 = Offset(center.dx + cos(rayAngle) * startDist, center.dy + sin(rayAngle) * startDist);
      final p2 = Offset(center.dx + cos(rayAngle) * endDist, center.dy + sin(rayAngle) * endDist);

      rayPaint
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFFFD54F),
            const Color(0xFFFF8F00).withOpacity(0.2),
          ],
        ).createShader(Rect.fromPoints(p1, p2))
        ..strokeWidth = dim * 0.045;

      canvas.drawLine(p1, p2, rayPaint);
    }

    // 3D Spherical Base Shading (Specular Highlight & Shadow)
    final sunShader = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 0.85,
      colors: const [
        Color(0xFFFFF9C4), // Highlight
        Color(0xFFFFB300), // Midtone
        Color(0xFFE65100), // Shadow
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sunPaint = Paint()..shader = sunShader;
    canvas.drawCircle(center, radius, sunPaint);

    // Inner Specular Glow Ring
    final specPaint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = dim * 0.02;
    canvas.drawCircle(Offset(center.dx - radius * 0.2, center.dy - radius * 0.2), radius * 0.35, specPaint);

    // Floating Solar Dust Particles
    for (var p in particles) {
      final pAngle = p.angle + progress * pi * p.speed;
      final dist = radius * (1.1 + p.x * 0.8);
      final px = center.dx + cos(pAngle) * dist;
      final py = center.dy + sin(pAngle) * dist;

      final particlePaint = Paint()
        ..color = const Color(0xFFFFE082).withOpacity(p.opacity * 0.8);
      canvas.drawCircle(Offset(px, py), p.size * (dim / 80), particlePaint);
    }
  }

  // --- 2. 3D VOLUMETRIC CLOUD ---
  void _draw3dCloud(Canvas canvas, Offset center, double dim, {double opacity = 1.0, Color? customColor}) {
    final cloudWidth = dim * 0.72;
    final cloudHeight = dim * 0.45;
    final cloudCenter = Offset(center.dx, center.dy + dim * 0.02);

    // Soft Drop Shadow for 3D Depth
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.18 * opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, dim * 0.08);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cloudCenter.dx, cloudCenter.dy + cloudHeight * 0.55),
        width: cloudWidth * 0.85,
        height: cloudHeight * 0.3,
      ),
      shadowPaint,
    );

    // Multi-Puff Volumetric Spheres with 3D Shading
    final baseColor = customColor ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFFE2E8F0));
    const highlightColor = Colors.white;
    final shadowColor = customColor ?? (isDark ? const Color(0xFF334155) : const Color(0xFF64748B));

    void drawVolumetricPuff(Offset puffCenter, double puffRadius, {Alignment lightAlign = const Alignment(-0.3, -0.4)}) {
      final puffShader = RadialGradient(
        center: lightAlign,
        radius: 0.8,
        colors: [
          highlightColor.withOpacity(opacity),
          baseColor.withOpacity(opacity),
          shadowColor.withOpacity(opacity),
        ],
        stops: const [0.1, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: puffCenter, radius: puffRadius));

      final puffPaint = Paint()..shader = puffShader;
      canvas.drawCircle(puffCenter, puffRadius, puffPaint);
    }

    // Left Puff
    drawVolumetricPuff(
      Offset(cloudCenter.dx - cloudWidth * 0.26, cloudCenter.dy + cloudHeight * 0.08),
      dim * 0.18,
    );

    // Right Puff
    drawVolumetricPuff(
      Offset(cloudCenter.dx + cloudWidth * 0.24, cloudCenter.dy + cloudHeight * 0.1),
      dim * 0.16,
    );

    // Top Main Puff
    drawVolumetricPuff(
      Offset(cloudCenter.dx - cloudWidth * 0.05, cloudCenter.dy - cloudHeight * 0.15),
      dim * 0.24,
    );

    // Front Center Bottom Pill Fill
    final bodyPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cloudCenter.dx, cloudCenter.dy + cloudHeight * 0.12),
          width: cloudWidth * 0.8,
          height: cloudHeight * 0.5,
        ),
        Radius.circular(dim * 0.15),
      ));

    final bodyShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        highlightColor.withOpacity(0.9 * opacity),
        baseColor.withOpacity(opacity),
      ],
    ).createShader(bodyPath.getBounds());

    canvas.drawPath(bodyPath, Paint()..shader = bodyShader);
  }

  // --- 3. 3D PARTLY CLOUDY (SUN BEHIND 3D CLOUD) ---
  void _draw3dPartlyCloudy(Canvas canvas, Offset center, double dim) {
    // 3D Sun in Top Right Background
    final sunCenter = Offset(center.dx + dim * 0.18, center.dy - dim * 0.16);
    _draw3dSun(canvas, sunCenter, dim * 0.72);

    // 3D Cloud in Foreground with Slight Sway
    final cloudOffset = sin(progress * pi * 2) * (dim * 0.02);
    final cloudCenter = Offset(center.dx - dim * 0.08 + cloudOffset, center.dy + dim * 0.08);

    _draw3dCloud(canvas, cloudCenter, dim * 0.9);
  }

  // --- 4. 3D RAIN ANIMATION (CLOUD + FALLING 3D DROPS) ---
  void _draw3dRain(Canvas canvas, Offset center, double dim, {required bool isHeavy}) {
    // 3D Cloud Base (Slightly darker for rain)
    final cloudCenter = Offset(center.dx, center.dy - dim * 0.12);
    final rainCloudColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    _draw3dCloud(canvas, cloudCenter, dim * 0.85, customColor: rainCloudColor);

    // 3D Raindrops falling in multi-depth perspective
    final dropCount = isHeavy ? 20 : 12;
    final dropSpeedMultiplier = isHeavy ? 2.8 : 1.8;

    for (int i = 0; i < dropCount; i++) {
      final p = particles[i % particles.length];
      final fallY = (p.y + progress * p.speed * dropSpeedMultiplier) % 1.0;
      final startX = center.dx - dim * 0.3 + (i * (dim * 0.6 / dropCount));
      final startY = cloudCenter.dy + dim * 0.12 + (fallY * dim * 0.45);

      final dropLength = dim * (0.08 + p.z * 0.06);
      final p1 = Offset(startX, startY);
      final p2 = Offset(startX - dim * 0.03, startY + dropLength);

      final dropShader = LinearGradient(
        colors: [
          const Color(0xFF38BDF8).withOpacity(p.opacity * p.z),
          const Color(0xFF0284C7).withOpacity(0.15),
        ],
      ).createShader(Rect.fromPoints(p1, p2));

      final dropPaint = Paint()
        ..shader = dropShader
        ..strokeWidth = dim * (0.02 + p.z * 0.015)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, dropPaint);
    }
  }

  // --- 5. 3D THUNDERSTORM (DARK CLOUD + RAIN + LIGHTNING FLASH) ---
  void _draw3dStorm(Canvas canvas, Offset center, double dim) {
    final stormCloudColor = isDark ? const Color(0xFF334155) : const Color(0xFF475569);
    final cloudCenter = Offset(center.dx, center.dy - dim * 0.14);

    // Lightning Flash burst trigger
    final flashCycle = (progress * 8) % 1.0;
    final isFlashing = flashCycle > 0.85;

    if (isFlashing) {
      final flashGlow = Paint()
        ..color = const Color(0xFFFDE047).withOpacity(0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, dim * 0.25);
      canvas.drawCircle(cloudCenter, dim * 0.5, flashGlow);
    }

    // Heavy Rain Drops
    _draw3dRain(canvas, center, dim, isHeavy: true);

    // 3D Dark Storm Cloud
    _draw3dCloud(canvas, cloudCenter, dim * 0.88, customColor: stormCloudColor);

    // Branching 3D Glowing Lightning Bolt
    if (isFlashing) {
      final boltPath = Path();
      final bx = center.dx + dim * 0.02;
      final by = cloudCenter.dy + dim * 0.15;

      boltPath.moveTo(bx, by);
      boltPath.lineTo(bx - dim * 0.08, by + dim * 0.14);
      boltPath.lineTo(bx + dim * 0.02, by + dim * 0.16);
      boltPath.lineTo(bx - dim * 0.06, by + dim * 0.32);

      // Bolt Outer Glow
      final boltGlow = Paint()
        ..color = const Color(0xFFFEF08A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = dim * 0.06
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, dim * 0.04);
      canvas.drawPath(boltPath, boltGlow);

      // Bolt Core White Specular
      final boltCore = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = dim * 0.025
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(boltPath, boltCore);
    }
  }

  // --- 6. 3D CRESCENT MOON (NIGHT) ---
  void _draw3dMoon(Canvas canvas, Offset center, double dim) {
    final radius = dim * 0.3;

    // Moonlight Cyan/Indigo Soft Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF38BDF8).withOpacity(0.3),
          const Color(0xFF6366F1).withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 2.0));
    canvas.drawCircle(center, radius * 2.0, glowPaint);

    // Twinkling 3D Starfield Background
    for (var p in particles) {
      final alpha = (sin(progress * pi * 4 + p.x * 20) + 1.0) / 2.0;
      final sx = center.dx + (p.x - 0.5) * dim * 1.1;
      final sy = center.dy + (p.y - 0.5) * dim * 1.1;

      final starPaint = Paint()
        ..color = Colors.white.withOpacity(alpha * p.opacity * 0.9);
      canvas.drawCircle(Offset(sx, sy), p.size * (dim / 90), starPaint);
    }

    // 3D Moon Sphere Base Shading
    final moonShader = RadialGradient(
      center: const Alignment(-0.4, -0.4),
      radius: 0.8,
      colors: const [
        Color(0xFFF8FAFC), // Highlight
        Color(0xFFCBD5E1), // Midtone
        Color(0xFF64748B), // Shadow
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, Paint()..shader = moonShader);

    // Shadow Overlay to shape Crescent
    final shadowCenter = Offset(center.dx - radius * 0.5, center.dy - radius * 0.25);
    final shadowColor = isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B);

    final shadowPaint = Paint()..color = shadowColor;
    canvas.drawCircle(shadowCenter, radius * 0.92, shadowPaint);
  }

  // --- 7. 3D PARTLY CLOUDY NIGHT ---
  void _draw3dPartlyCloudyNight(Canvas canvas, Offset center, double dim) {
    final moonCenter = Offset(center.dx + dim * 0.16, center.dy - dim * 0.16);
    _draw3dMoon(canvas, moonCenter, dim * 0.7);

    final cloudCenter = Offset(center.dx - dim * 0.08, center.dy + dim * 0.08);
    final nightCloudColor = isDark ? const Color(0xFF475569) : const Color(0xFF64748B);

    _draw3dCloud(canvas, cloudCenter, dim * 0.88, customColor: nightCloudColor);
  }

  // --- 8. 3D SNOW ANIMATION ---
  void _draw3dSnow(Canvas canvas, Offset center, double dim) {
    final cloudCenter = Offset(center.dx, center.dy - dim * 0.14);
    _draw3dCloud(canvas, cloudCenter, dim * 0.85);

    // Floating Swaying 3D Snowflakes
    for (int i = 0; i < 14; i++) {
      final p = particles[i];
      final fallY = (p.y + progress * p.speed * 0.6) % 1.0;
      final swayX = sin(progress * pi * 2 + p.y * 10) * (dim * 0.06);

      final sx = center.dx - dim * 0.3 + (p.x * dim * 0.6) + swayX;
      final sy = cloudCenter.dy + dim * 0.12 + (fallY * dim * 0.45);

      final snowPaint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * p.z)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.z * 1.2);

      canvas.drawCircle(Offset(sx, sy), (dim * 0.025) * p.z, snowPaint);
    }
  }

  // --- 9. 3D FOG ANIMATION ---
  void _draw3dFog(Canvas canvas, Offset center, double dim) {
    for (int i = 0; i < 4; i++) {
      final shift = sin(progress * pi * 2 + i * 1.2) * (dim * 0.08);
      final fy = center.dy - dim * 0.2 + (i * dim * 0.12);

      final fogRect = Rect.fromCenter(
        center: Offset(center.dx + shift, fy),
        width: dim * 0.8,
        height: dim * 0.08,
      );

      final fogPaint = Paint()
        ..color = (isDark ? const Color(0xFF94A3B8) : const Color(0xFFCBD5E1)).withOpacity(0.4 - i * 0.07)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, dim * 0.06);

      canvas.drawRRect(RRect.fromRectAndRadius(fogRect, Radius.circular(dim * 0.04)), fogPaint);
    }
  }

  // --- 10. 3D WIND ANIMATION ---
  void _draw3dWind(Canvas canvas, Offset center, double dim) {
    final windPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = dim * 0.035;

    for (int i = 0; i < 4; i++) {
      final flow = ((progress + i * 0.25) % 1.0);
      final startX = center.dx - dim * 0.4 + (flow * dim * 0.8);
      final wy = center.dy - dim * 0.2 + (i * dim * 0.14);

      final path = Path();
      path.moveTo(startX - dim * 0.2, wy);
      path.quadraticBezierTo(startX, wy - dim * 0.05, startX + dim * 0.15, wy);

      windPaint.color = (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7)).withOpacity((1.0 - flow) * 0.7);
      canvas.drawPath(path, windPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _Weather3dIconPainter oldDelegate) => true;
}
