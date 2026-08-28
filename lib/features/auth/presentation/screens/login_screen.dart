import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';
import '../../../../core/widgets/mausam_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'aarav@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'Password123');
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      context.go('/location/permission');
    } else if (mounted) {
      setState(() {
        _error = ref.read(authProvider).errorMessage ??
            'Login failed. Please try again.';
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
                'Welcome Back!',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Login to continue to your personalized weather experience.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 32),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.statusDanger.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.statusDanger.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.statusDanger, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _error!,
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.statusDanger),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Email / Mobile Field
              MausamTextField(
                controller: _emailController,
                label: 'Email / Mobile',
                hintText: 'Enter your email or phone',
                prefixIcon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),

              // Password Field
              MausamTextField(
                controller: _passwordController,
                label: 'Password',
                hintText: 'Enter your password',
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
              const SizedBox(height: 10),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/auth/forgot-password'),
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              MausamButton(
                text: 'Login',
                width: double.infinity,
                isLoading: authState.isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'OR',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textDarkMuted
                            : AppColors.textLightMuted,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder)),
                ],
              ),
              const SizedBox(height: 24),

              // OTP Login Option
              MausamButton(
                text: 'Login with OTP',
                variant: ButtonVariant.secondary,
                width: double.infinity,
                icon: Icons.sms_outlined,
                onPressed: () => context.push('/auth/otp'),
              ),
              const SizedBox(height: 32),

              // Sign Up Redirection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/auth/signup'),
                    child: Text(
                      'Sign Up',
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
