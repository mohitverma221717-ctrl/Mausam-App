import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/mausam_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      title: 'Personalized Weather For You',
      subtitle: 'Only what matters to you, when you need it.',
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.accentCyan,
      tag: 'Smart Tailoring',
    ),
    _OnboardingSlide(
      title: 'For Every Lifestyle',
      subtitle:
          'Health, Fitness, Travel, Family, Farming & outdoor activities.',
      icon: Icons.dashboard_customize_rounded,
      accentColor: AppColors.primaryBlue,
      tag: '8 Specialized Domains',
    ),
    _OnboardingSlide(
      title: 'Accurate, Reliable, Always with You',
      subtitle:
          'Real-time IMD Weather data, live radar & instant smart alerts.',
      icon: Icons.radar_rounded,
      accentColor: Color(0xFF00E676),
      tag: 'IMD Powered',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Skip button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.accentCyan,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'MAUSAM',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/get-started'),
                    child: Text(
                      'Skip',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark
                            ? AppColors.textDarkMuted
                            : AppColors.textLightMuted,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Carousel Slider
              SizedBox(
                height: 380,
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

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Hero Visual Card
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                slide.accentColor.withOpacity(0.25),
                                AppColors.primaryBlue.withOpacity(0.08),
                              ],
                            ),
                            border: Border.all(
                              color: slide.accentColor.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              slide.icon,
                              size: 80,
                              color: slide.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: slide.accentColor.withOpacity(0.15),
                            borderRadius: AppRadius.brPill,
                          ),
                          child: Text(
                            slide.tag,
                            style: AppTypography.labelSmall.copyWith(
                              color: slide.accentColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          slide.title,
                          style: AppTypography.headlineMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slide.subtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(),

              // Pagination Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (index) {
                  final isSelected = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSelected ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Action Button
              MausamButton(
                text:
                    _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                width: double.infinity,
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.go('/get-started');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String tag;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.tag,
  });
}
