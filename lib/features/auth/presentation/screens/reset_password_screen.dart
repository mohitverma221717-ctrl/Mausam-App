import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../../../core/widgets/mausam_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _reset() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset successfully! Please login.'),
        backgroundColor: AppColors.statusSuccess,
      ),
    );
    context.go('/auth/login');
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
                'Set New Password',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a strong password with at least 8 characters.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 32),
              MausamTextField(
                controller: _passController,
                label: 'New Password',
                hintText: 'Enter new password',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscure1,
                suffixIcon: IconButton(
                  icon: Icon(_obscure1
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
              ),
              const SizedBox(height: 18),
              MausamTextField(
                controller: _confirmPassController,
                label: 'Confirm New Password',
                hintText: 'Re-enter new password',
                prefixIcon: Icons.lock_reset_rounded,
                obscureText: _obscure2,
                suffixIcon: IconButton(
                  icon: Icon(_obscure2
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
              ),
              const SizedBox(height: 28),
              MausamButton(
                text: 'Update Password',
                width: double.infinity,
                onPressed: _reset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
