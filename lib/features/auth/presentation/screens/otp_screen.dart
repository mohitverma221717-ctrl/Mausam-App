import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController(text: '${index + 2}'));
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _controllers.map((e) => e.text).join();
    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.verifyOtp(otp);

    if (success && mounted) {
      context.go('/location/permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Your Number',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit verification code sent to +91 9876543210',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 36),

              // 6 OTP Digit Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSurfaceElevated
                            : AppColors.lightBackgroundSecondary,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Resend Code timer
              Center(
                child: Text(
                  'Resend Code in 00:25',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.textDarkMuted
                        : AppColors.textLightMuted,
                  ),
                ),
              ),
              const Spacer(),

              // Verify Button
              MausamButton(
                text: 'Verify & Continue',
                width: double.infinity,
                isLoading: authState.isLoading,
                onPressed: _verifyOtp,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
