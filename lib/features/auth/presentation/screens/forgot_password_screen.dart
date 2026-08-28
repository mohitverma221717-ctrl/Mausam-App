import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../../../core/widgets/mausam_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'aarav@gmail.com');
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendLink() {
    setState(() {
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                'Reset Password',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email or mobile to receive password reset instructions.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 32),
              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.statusSuccess.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.statusSuccess.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.statusSuccess),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Password reset instructions sent! Please check your inbox.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              MausamTextField(
                controller: _emailController,
                label: 'Email / Mobile',
                hintText: 'Enter your email or phone',
                prefixIcon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 28),
              MausamButton(
                text: _sent ? 'Open Reset Page' : 'Send Reset Link',
                width: double.infinity,
                onPressed: () {
                  if (_sent) {
                    context.push('/auth/reset-password');
                  } else {
                    _sendLink();
                  }
                },
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Back to Login',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.accentCyan,
                      fontWeight: FontWeight.w600,
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
}
