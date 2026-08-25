import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mausam_button.dart';

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({super.key});

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  final TextEditingController _feedbackCtrl = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How does personalized weather card ranking work?',
      'a':
          'MAUSAM uses a dynamic scoring engine combining your selected interest priorities, active weather alarms (e.g. rain boost, high UV boost), and current time-of-day to order cards on your dashboard.',
    },
    {
      'q': 'Where does the radar data originate?',
      'a':
          'Radar scans are pulled from Doppler weather radar composite networks under the India Meteorological Department and international radar arrays.',
    },
    {
      'q': 'Can I add multiple cities and family commute routes?',
      'a':
          'Yes, you can save unlimited custom locations in Saved Places and add dedicated routes for family members under the Family and Commute modules.',
    },
    {
      'q': 'Are offline weather views supported?',
      'a':
          'Yes, if network connectivity drops, MAUSAM automatically serves the latest cached meteorological forecast.',
    },
  ];

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_feedbackCtrl.text.trim().isNotEmpty) {
      _feedbackCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Thank you! Your feedback has been submitted to the engineering team.'),
          backgroundColor: AppColors.statusSuccess,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Help & Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard
                    : AppColors.lightSurfaceCard,
                borderRadius: AppRadius.brXl,
                border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: _faqs.map((faq) {
                  return ExpansionTile(
                    title: Text(
                      faq['q']!,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Text(
                          faq['a']!,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Send Feedback / Report an Issue',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceCard
                    : AppColors.lightSurfaceCard,
                borderRadius: AppRadius.brXl,
                border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Describe your issue or suggest a feature:',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _feedbackCtrl,
                    maxLines: 4,
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightBackgroundSecondary,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.brMd,
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MausamButton(
                    text: 'Submit Feedback',
                    width: double.infinity,
                    onPressed: _submitFeedback,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
