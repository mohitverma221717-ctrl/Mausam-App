import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/alerts/domain/models/weather_alert.dart';

class SeverityBadge extends StatelessWidget {
  final AlertSeverity severity;
  final String? customText;

  const SeverityBadge({
    super.key,
    required this.severity,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    final color = severity.color;
    final text = customText ?? severity.displayName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: AppRadius.brPill,
        border: Border.all(color: color.withOpacity(0.6), width: 1),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
