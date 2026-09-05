import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({super.key});

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final name = _nameController.text.trim();
    final displayName = name.isNotEmpty ? name : 'Explorer';

    // Update profile with user's entered name
    ref.read(authProvider.notifier).updateProfile(name: displayName);

    // Smoothly navigate to the next onboarding page
    context.go('/location/permission');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      body: Stack(
        children: [
          // 1. Constellation / Celestial Topography Map Custom Canvas
          Positioned.fill(
            child: CustomPaint(
              painter: _CelestialMapPainter(),
            ),
          ),

          // 2. Ambient Glowing Nebula Blobs
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1E3A8A).withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0284C7).withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const Spacer(flex: 3),

                          // Glowing Sky Blue Circle with Cloud & Sync Arrows Icon
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF38BDF8),
                                  Color(0xFF2563EB),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF38BDF8).withOpacity(0.45),
                                  blurRadius: 36,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Refresh / Sync Arrows + Cloud Custom Graphic
                                  CustomPaint(
                                    size: const Size(68, 68),
                                    painter: _CloudSyncIconPainter(),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),

                          // Heading
                          Text(
                            "Let's Get Started",
                            style: AppTypography.headlineLarge.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Subtitle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Tell us who you are to personalize your daily weather forecast.',
                              style: AppTypography.bodyMedium.copyWith(
                                color: const Color(0xFF94A3B8),
                                fontSize: 15,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const Spacer(flex: 4),

                          // Glowing Name Input Field
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withOpacity(0.75),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _isFocused
                                    ? const Color(0xFF38BDF8)
                                    : const Color(0xFF1E3A5F).withOpacity(0.8),
                                width: _isFocused ? 1.6 : 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _isFocused
                                      ? const Color(0xFF38BDF8).withOpacity(0.30)
                                      : const Color(0xFF1E3A5F).withOpacity(0.15),
                                  blurRadius: _isFocused ? 18 : 10,
                                  spreadRadius: _isFocused ? 1 : 0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _nameController,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              cursorColor: const Color(0xFF38BDF8),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _handleContinue(),
                              decoration: InputDecoration(
                                hintText: 'Your Name',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // "Continue" Action Button
                          Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF3B82F6),
                                  Color(0xFF2563EB),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withOpacity(0.40),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: _handleContinue,
                                child: const Center(
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),

                          // Subtle Sparkle Glint at Bottom Right
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0, bottom: 8.0),
                              child: Icon(
                                Icons.auto_awesome,
                                size: 26,
                                color: const Color(0xFF334155).withOpacity(0.7),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the cloud + curved sync arrows icon matching Image 2
class _CloudSyncIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.5, size.height * 0.5);

    // 1. Left Counter-Clockwise Curved Arrow
    final leftArcPath = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(center.dx - 4, center.dy), radius: 22),
        math.pi * 0.5,
        math.pi * 0.8,
      );
    canvas.drawPath(leftArcPath, paint);

    // Arrowhead on left arc
    final arrowLeft = Path()
      ..moveTo(center.dx - 26, center.dy + 12)
      ..lineTo(center.dx - 16, center.dy + 12)
      ..lineTo(center.dx - 16, center.dy + 2)
      ..close();
    canvas.drawPath(arrowLeft, fillPaint);

    // 2. Right Arrow (pointing up-right)
    final arrowRight = Path()
      ..moveTo(center.dx + 4, center.dy - 12)
      ..lineTo(center.dx + 4, center.dy - 22)
      ..lineTo(center.dx + 16, center.dy - 22)
      ..lineTo(center.dx + 16, center.dy - 10)
      ..moveTo(center.dx + 16, center.dy - 22)
      ..lineTo(center.dx + 6, center.dy - 12);
    canvas.drawPath(
      arrowRight,
      paint..strokeWidth = 4.0,
    );

    // 3. Weather Cloud Shape on lower right
    final cloudPath = Path();
    final cloudBaseY = center.dy + 15;
    final cloudLeftX = center.dx - 3;
    final cloudRightX = center.dx + 25;

    cloudPath.moveTo(cloudLeftX + 5, cloudBaseY);
    cloudPath.lineTo(cloudRightX - 4, cloudBaseY);
    cloudPath.arcToPoint(
      Offset(cloudRightX, cloudBaseY - 5),
      radius: const Radius.circular(5),
    );
    cloudPath.arcToPoint(
      Offset(cloudRightX - 8, cloudBaseY - 12),
      radius: const Radius.circular(8),
    );
    cloudPath.arcToPoint(
      Offset(cloudLeftX + 8, cloudBaseY - 14),
      radius: const Radius.circular(10),
    );
    cloudPath.arcToPoint(
      Offset(cloudLeftX, cloudBaseY - 5),
      radius: const Radius.circular(6),
    );
    cloudPath.close();

    canvas.drawPath(cloudPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the celestial constellation and topography isobar curves
class _CelestialMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final starPaint = Paint()
      ..color = const Color(0xFF64748B).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Topography isobars in top right
    final topoPath1 = Path()
      ..moveTo(size.width * 0.5, 0)
      ..cubicTo(size.width * 0.6, 60, size.width * 0.8, 30, size.width, 80);
    canvas.drawPath(topoPath1, linePaint);

    final topoPath2 = Path()
      ..moveTo(size.width * 0.65, 0)
      ..cubicTo(size.width * 0.75, 45, size.width * 0.85, 20, size.width, 50);
    canvas.drawPath(topoPath2, linePaint);

    // Constellation lines in top left
    final constPath = Path()
      ..moveTo(size.width * 0.1, 40)
      ..lineTo(size.width * 0.25, 70)
      ..lineTo(size.width * 0.35, 45)
      ..lineTo(size.width * 0.45, 90);
    canvas.drawPath(constPath, linePaint);

    // Stars on constellation
    canvas.drawCircle(Offset(size.width * 0.1, 40), 2.0, starPaint);
    canvas.drawCircle(Offset(size.width * 0.25, 70), 2.5, starPaint);
    canvas.drawCircle(Offset(size.width * 0.35, 45), 2.0, starPaint);
    canvas.drawCircle(Offset(size.width * 0.45, 90), 3.0, starPaint);

    // Extra scattered stars
    canvas.drawCircle(Offset(size.width * 0.15, 120), 1.5, starPaint);
    canvas.drawCircle(Offset(size.width * 0.85, 110), 1.8, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
