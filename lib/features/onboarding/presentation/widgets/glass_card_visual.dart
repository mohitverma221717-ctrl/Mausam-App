import 'dart:ui';
import 'package:flutter/material.dart';
import 'crystal_sparkle_painter.dart';

class GlassCardVisual extends StatelessWidget {
  final int slideIndex;
  final double animationValue;

  const GlassCardVisual({
    super.key,
    required this.slideIndex,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 280,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Ambient Glow Blob behind card
              Positioned(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getAmbientColor(slideIndex).withOpacity(0.35),
                        blurRadius: 50,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Back Frosted Glass Sheet Layer (Left-Right Staggered 3D Depth Flaps)
              Container(
                width: 254,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),

              // 3. Middle Frosted Glass Layer
              Container(
                width: 240,
                height: 196,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 1.2,
                  ),
                ),
              ),

              // 4. Main Front Frosted Glass Card (214 x 214, Radius 36)
              ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: 214,
                    height: 214,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.22),
                          Colors.white.withOpacity(0.06),
                          Colors.white.withOpacity(0.02),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.38),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                        BoxShadow(
                          color: _getAmbientColor(slideIndex).withOpacity(0.25),
                          blurRadius: 24,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Subtle diagonal gloss highlight across glass
                        Positioned(
                          top: -36,
                          left: -36,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withOpacity(0.25),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Card Content Based on Slide Index
                        _buildCardVisualContent(slideIndex, animationValue),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAmbientColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF38BDF8);
      case 1:
        return const Color(0xFF3B82F6);
      case 2:
      default:
        return const Color(0xFF10B981);
    }
  }

  Widget _buildCardVisualContent(int index, double anim) {
    if (index == 0) {
      return SizedBox(
        width: 170,
        height: 170,
        child: CustomPaint(
          painter: CrystalSparklesPainter(animationValue: anim),
        ),
      );
    } else if (index == 1) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.5),
                  const Color(0xFF8B5CF6).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const Icon(
            Icons.dashboard_customize_rounded,
            size: 64,
            color: Color(0xFF60A5FA),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF34D399).withOpacity(0.4),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF34D399).withOpacity(0.6),
                width: 1.5,
              ),
            ),
          ),
          const Icon(
            Icons.radar_rounded,
            size: 58,
            color: Color(0xFF34D399),
          ),
        ],
      );
    }
  }
}
