import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../../../core/widgets/mausam_text_field.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _agreeToTerms = true;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (!_agreeToTerms) {
      setState(() {
        _error = 'Please agree to the Terms & Privacy Policy.';
      });
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.signUp(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      context.push('/auth/otp');
    } else if (mounted) {
      setState(() {
        _error = ref.read(authProvider).errorMessage ?? 'Registration failed.';
      });
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign up to customize your personalized weather alerts and forecast view.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 28),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.statusDanger.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.statusDanger.withOpacity(0.5)),
                  ),
                  child: Text(
                    _error!,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.statusDanger),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Full Name
              MausamTextField(
                controller: _nameController,
                label: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 18),

              // Email / Mobile
              MausamTextField(
                controller: _emailController,
                label: 'Email / Mobile',
                hintText: 'Enter email or phone number',
                prefixIcon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),

              // Password
              MausamTextField(
                controller: _passwordController,
                label: 'Password',
                hintText: 'Create a secure password',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: isDark
                        ? AppColors.textDarkMuted
                        : AppColors.textLightMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Terms & Privacy Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _agreeToTerms,
                      activeColor: AppColors.primaryBlue,
                      onChanged: (val) {
                        setState(() {
                          _agreeToTerms = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'I agree to ',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/auth/terms'),
                          child: Text(
                            'Terms',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          ' & ',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/auth/privacy'),
                          child: Text(
                            'Privacy Policy',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Submit Button
              MausamButton(
                text: 'Create Account',
                width: double.infinity,
                isLoading: authState.isLoading,
                onPressed: _handleSignUp,
              ),
              const SizedBox(height: 24),

              // Back to login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Login',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
