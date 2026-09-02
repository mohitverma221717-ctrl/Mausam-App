import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';

import 'weather_3d_icon_widget.dart';

class WeatherHeroCard extends StatelessWidget {
  final WeatherData weather;
  final VoidCallback? onTap;

  const WeatherHeroCard({
    super.key,
    required this.weather,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.brXl,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(22.0),
          decoration: BoxDecoration(
            borderRadius: AppRadius.brXl,
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF162238),
                      Color(0xFF0F172A),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF8FAFC),
                    ],
                  ),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF263859)
                  : AppColors.lightBorder,
              width: 1,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                      spreadRadius: -2,
                    ),
                    const BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x0A0F172A),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Temperature & Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${weather.temperature.toInt()}',
                          style: AppTypography.serifHeroTemperature.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColors.textLightPrimary,
                            fontSize: 66,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, left: 3.0),
                          child: Text(
                            '°C',
                            style: AppTypography.titleLarge.copyWith(
                              color: isDark
                                  ? AppColors.accentCyan
                                  : const Color(0xFF0284C7),
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.condition,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        letterSpacing: -0.2,
                        color: isDark
                            ? Colors.white
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.accentCyan.withOpacity(0.1)
                            : const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Feels like ${weather.feelsLike.toInt()}°',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.accentCyan
                              : const Color(0xFF0369A1),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Volumetric 3D Animated Weather Graphic
              SizedBox(
                width: 90,
                height: 90,
                child: Weather3dIconWidget(
                  conditionType: weather.conditionType,
                  size: 90,
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

