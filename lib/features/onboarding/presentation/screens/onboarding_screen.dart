import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/glass_card_visual.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _sparkleController;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      title: 'Personalized Weather For You',
      subtitle: 'Only what matters to you, when you need it.',
      accentColor: Color(0xFF38BDF8),
      tag: 'Smart Tailoring',
    ),
    _OnboardingSlide(
      title: 'For Every Lifestyle',
      subtitle:
          'Health, Fitness, Travel, Family, Farming & outdoor activities.',
      accentColor: Color(0xFF3B82F6),
      tag: '8 Specialized Domains',
    ),
    _OnboardingSlide(
      title: 'Accurate, Reliable, Always with You',
      subtitle:
          'Real-time IMD Weather data, live radar & instant smart alerts.',
      accentColor: Color(0xFF10B981),
      tag: 'IMD Powered',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F17),
      body: Stack(
        children: [
          // 1. Cinematic Background Nebula Glows
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
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
            bottom: 100,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0369A1).withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 2. Foreground Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 680;
                final isVeryCompact = constraints.maxHeight < 600;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: isVeryCompact ? 6.0 : 12.0,
                  ),
                  child: Column(
                    children: [
                      // Top Header: Logo + Skip Button
                      _buildTopHeader(context),

                      // Responsive Flexible Center Carousel (Zero Overflow)
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _slides.length,
                          itemBuilder: (context, index) {
                            final slide = _slides[index];

                            return AnimatedBuilder(
                              animation: _sparkleController,
                              builder: (context, child) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(flex: 1),

                                    // 3D Frosted Glass Layered Hero Card (Flexible / Scaled)
                                    Flexible(
                                      flex: 8,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: GlassCardVisual(
                                          slideIndex: index,
                                          animationValue:
                                              _sparkleController.value,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: isVeryCompact
                                          ? 12
                                          : (isCompact ? 16 : 24),
                                    ),

                                    // Tag Badge
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isVeryCompact ? 12 : 16,
                                        vertical: isVeryCompact ? 4 : 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            slide.accentColor.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: slide.accentColor
                                              .withOpacity(0.40),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Text(
                                        slide.tag,
                                        style: AppTypography.labelSmall
                                            .copyWith(
                                          color: slide.accentColor,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                          fontSize: isVeryCompact ? 11 : 12,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: isVeryCompact
                                          ? 8
                                          : (isCompact ? 10 : 14),
                                    ),

                                    // Main Title
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        slide.title,
                                        style: AppTypography.headlineMedium
                                            .copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontSize: isVeryCompact
                                              ? 20
                                              : (isCompact ? 22 : 25),
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    SizedBox(
                                      height: isVeryCompact
                                          ? 6
                                          : (isCompact ? 8 : 10),
                                    ),

                                    // Subtitle
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        slide.subtitle,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                          color: const Color(0xFF94A3B8),
                                          fontSize: isVeryCompact
                                              ? 13
                                              : (isCompact ? 14 : 15),
                                          height: 1.35,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    const Spacer(flex: 1),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // Pagination Dots Indicator
                      _buildPageIndicator(),

                      SizedBox(
                        height:
                            isVeryCompact ? 12 : (isCompact ? 16 : 22),
                      ),

                      // Bottom Action Button with Sparkle Glint
                      _buildActionButton(context, isVeryCompact),

                      SizedBox(height: isVeryCompact ? 4 : 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Glowing Sun Logo + Brand Name
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.wb_sunny_outlined,
                color: Color(0xFF67E8F9),
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'MAUSAM',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),

        // Frosted Pill "Skip" Button
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go('/get-started'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132030).withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF263D57),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTypography.labelMedium.copyWith(
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final isSelected = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isSelected ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.7),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(BuildContext context, bool isVeryCompact) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Vibrant Blue Next Button
        Container(
          width: double.infinity,
          height: isVeryCompact ? 48 : 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
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
                color: const Color(0xFF2563EB).withOpacity(0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.20),
              width: 1.0,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                if (_currentPage < _slides.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                  );
                } else {
                  context.go('/get-started');
                }
              },
              child: Center(
                child: Text(
                  _currentPage == _slides.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Corner Sparkle Star Glint
        Positioned(
          top: 6,
          right: 28,
          child: AnimatedBuilder(
            animation: _sparkleController,
            builder: (context, child) {
              final scale = 1.0 +
                  0.25 *
                      (0.5 +
                          0.5 *
                              (_sparkleController.value > 0.5
                                  ? (1.0 - _sparkleController.value)
                                  : _sparkleController.value));
              return Transform.scale(
                scale: scale,
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFBAE6FD),
                  size: 18,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String subtitle;
  final Color accentColor;
  final String tag;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.tag,
  });
}
