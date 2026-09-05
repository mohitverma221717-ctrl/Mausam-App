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
      child: SizedBox(
        width: 280,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Ambient Glow Blob behind card
            Positioned(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getAmbientColor(slideIndex).withOpacity(0.35),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

            // 2. Back Frosted Glass Sheet Layer (Left-Right Staggered 3D Depth Flaps)
            Container(
              width: 262,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
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
              width: 248,
              height: 208,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
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

            // 4. Main Front Frosted Glass Card (224 x 224, Radius 38)
            ClipRRect(
              borderRadius: BorderRadius.circular(38),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: 224,
                  height: 224,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38),
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
                        top: -40,
                        left: -40,
                        child: Container(
                          width: 140,
                          height: 140,
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
    );
  }

  Color _getAmbientColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF38BDF8); // Cyan / Sparkle
      case 1:
        return const Color(0xFF3B82F6); // Royal Blue / Lifestyle
      case 2:
      default:
        return const Color(0xFF10B981); // Emerald / Radar
    }
  }

  Widget _buildCardVisualContent(int index, double anim) {
    if (index == 0) {
      // 3D Iridescent Crystal Sparkles (Matching Image 1)
      return SizedBox(
        width: 180,
        height: 180,
        child: CustomPaint(
          painter: CrystalSparklesPainter(animationValue: anim),
        ),
      );
    } else if (index == 1) {
      // Slide 2: 3D Lifestyle Prism with floating icons
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
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
            size: 68,
            color: Color(0xFF60A5FA),
          ),
        ],
      );
    } else {
      // Slide 3: 3D Radar Weather Scanner with pulse rings
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF34D399).withOpacity(0.4),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: 70,
            height: 70,
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
            size: 64,
            color: Color(0xFF34D399),
          ),
        ],
      );
    }
  }
}
