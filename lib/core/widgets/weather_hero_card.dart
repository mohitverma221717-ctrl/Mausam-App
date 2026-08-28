import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/weather/domain/models/weather_data.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          decoration: BoxDecoration(
            borderRadius: AppRadius.brXl,
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF182542),
                      Color(0xFF111A2E),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFEEF4FC),
                    ],
                  ),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isDark ? const Color(0x33000000) : const Color(0x1A2979FF),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Temperature & Condition
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature.toInt()}',
                              style: AppTypography.temperatureHero.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                            Text(
                              '°C',
                              style: AppTypography.displaySmall.copyWith(
                                color: AppColors.accentCyan,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weather.condition,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              'Feels like ${weather.feelsLike.toInt()}°',
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textLightSecondary,
                              ),
                            ),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? AppColors.textDarkMuted
                                    : AppColors.textLightMuted,
                              ),
                            ),
                            Text(
                              'H: ${weather.tempMax.toInt()}°  L: ${weather.tempMin.toInt()}°',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textLightSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Animated Weather Icon / Badge
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryBlue.withOpacity(0.3),
                          AppColors.accentCyan.withOpacity(0.15),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        weather.iconData,
                        size: 54,
                        color:
                            weather.conditionType == WeatherConditionType.sunny
                                ? const Color(0xFFFFB300)
                                : (isDark
                                    ? AppColors.accentCyan
                                    : AppColors.primaryBlue),
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
