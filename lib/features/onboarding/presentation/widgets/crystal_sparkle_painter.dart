import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Draws high-precision 3D iridescent crystal stars with multi-faceted diamond shading
class CrystalSparklesPainter extends CustomPainter {
  final double animationValue;

  CrystalSparklesPainter({this.animationValue = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);

    // 1. Ambient Background Glow behind stars
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF38BDF8).withOpacity(0.35),
          const Color(0xFF818CF8).withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.45));
    canvas.drawCircle(center, size.width * 0.45, glowPaint);

    // 2. Center Main Large 3D Crystal Star
    final mainStarCenter = Offset(center.dx - 12, center.dy + 4);
    _drawFacetedCrystalStar(
      canvas: canvas,
      center: mainStarCenter,
      radius: 46.0,
      rotation: 0.08 + math.sin(animationValue * math.pi * 2) * 0.03,
      pulse: 1.0 + math.sin(animationValue * math.pi * 2) * 0.04,
    );

    // 3. Top-Right Medium 3D Crystal Star
    final topRightCenter = Offset(center.dx + 38, center.dy - 34);
    _drawFacetedCrystalStar(
      canvas: canvas,
      center: topRightCenter,
      radius: 26.0,
      rotation: -0.12 - math.cos(animationValue * math.pi * 2) * 0.03,
      pulse: 1.0 + math.cos(animationValue * math.pi * 2) * 0.05,
    );

    // 4. Bottom-Right Small 3D Crystal Star
    final bottomRightCenter = Offset(center.dx + 36, center.dy + 26);
    _drawFacetedCrystalStar(
      canvas: canvas,
      center: bottomRightCenter,
      radius: 20.0,
      rotation: 0.15 + math.sin(animationValue * math.pi * 2 + 1) * 0.04,
      pulse: 1.0 + math.sin(animationValue * math.pi * 2 + 1) * 0.05,
    );

    // 5. Delicate Micro Glints / Flares
    _drawMicroFlare(canvas, mainStarCenter, 14.0 * (1.0 + math.sin(animationValue * math.pi * 4) * 0.2));
    _drawMicroFlare(canvas, topRightCenter, 8.0 * (1.0 + math.cos(animationValue * math.pi * 4) * 0.2));
    _drawMicroFlare(canvas, bottomRightCenter, 6.0 * (1.0 + math.sin(animationValue * math.pi * 4) * 0.2));
  }

  void _drawFacetedCrystalStar({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double rotation,
    required double pulse,
  }) {
    final currentRadius = radius * pulse;
    final innerRadius = currentRadius * 0.28;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // 4 main vertices: Top, Right, Bottom, Left
    final top = Offset(0, -currentRadius);
    final right = Offset(currentRadius, 0);
    final bottom = Offset(0, currentRadius);
    final left = Offset(-currentRadius, 0);

    // 4 inner vertices
    final inTR = Offset(innerRadius, -innerRadius);
    final inBR = Offset(innerRadius, innerRadius);
    final inBL = Offset(-innerRadius, innerRadius);
    final inTL = Offset(-innerRadius, -innerRadius);

    // Shading facets (Top-Left facet, Top-Right facet, etc.)
    // Facet 1: Top -> InTR -> Center
    _drawFacet(
      canvas,
      [Offset.zero, inTR, top],
      const [Color(0xFFE0F2FE), Color(0xFFBAE6FD), Color(0xFFFFFFFF)],
    );

    // Facet 2: Top -> InTL -> Center
    _drawFacet(
      canvas,
      [Offset.zero, inTL, top],
      const [Color(0xFFF8FAFC), Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
    );

    // Facet 3: Right -> InTR -> Center
    _drawFacet(
      canvas,
      [Offset.zero, right, inTR],
      const [Color(0xFFDDD6FE), Color(0xFFC4B5FD), Color(0xFFA78BFA)],
    );

    // Facet 4: Right -> InBR -> Center
    _drawFacet(
      canvas,
      [Offset.zero, inBR, right],
      const [Color(0xFF7DD3FC), Color(0xFF38BDF8), Color(0xFF0284C7)],
    );

    // Facet 5: Bottom -> InBR -> Center
    _drawFacet(
      canvas,
      [Offset.zero, inBR, bottom],
      const [Color(0xFF93C5FD), Color(0xFF60A5FA), Color(0xFF3B82F6)],
    );

    // Facet 6: Bottom -> InBL -> Center
    _drawFacet(
      canvas,
      [Offset.zero, inBL, bottom],
      const [Color(0xFFC084FC), Color(0xFFA855F7), Color(0xFF9333EA)],
    );

    // Facet 7: Left -> InBL -> Center
    _drawFacet(
      canvas,
      [Offset.zero, left, inBL],
      const [Color(0xFFE0E7FF), Color(0xFFC7D2FE), Color(0xFF818CF8)],
    );

    // Facet 8: Left -> InTL -> Center
    _drawFacet(
      canvas,
      [Offset.zero, left, inTL],
      const [Color(0xFFFFFFFF), Color(0xFFF0F9FF), Color(0xFFBAE6FD)],
    );

    // Prismatic Center Specular Glow Highlight
    final specularPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.95),
          const Color(0xFFE0F2FE).withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: innerRadius * 1.6));
    canvas.drawCircle(Offset.zero, innerRadius * 1.6, specularPaint);

    // Star Outline / Crystal Bevel Line
    final bevelPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final outlinePath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(inTR.dx, inTR.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(inBR.dx, inBR.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(inBL.dx, inBL.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(inTL.dx, inTL.dy)
      ..close();

    canvas.drawPath(outlinePath, bevelPaint);

    canvas.restore();
  }

  void _drawFacet(Canvas canvas, List<Offset> points, List<Color> colors) {
    final path = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..close();

    final bounds = path.getBounds();
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(bounds)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  void _drawMicroFlare(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + size, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + size)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - size, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - size)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CrystalSparklesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
