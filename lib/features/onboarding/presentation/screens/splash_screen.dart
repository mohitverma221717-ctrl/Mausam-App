import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      if (authState.isFirstTime) {
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Weather Sun + Cloud Glow Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryBlue,
                        AppColors.accentCyan,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withOpacity(0.4),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'MAUSAM',
                  style: AppTypography.displaySmall.copyWith(
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'PERSONALIZED WEATHER',
                  style: AppTypography.labelMedium.copyWith(
                    letterSpacing: 2.0,
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 64),
                // Footer attribution
                Text(
                  'India Meteorological Department • MoES',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textDarkMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
