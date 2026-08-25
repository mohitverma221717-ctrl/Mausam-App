import '../../domain/models/health_models.dart';
import '../../../../../core/theme/app_colors.dart';

class MockHealthRepository {
  Future<HealthData> getHealthData(String locationName) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const HealthData(
      aqi: 82,
      aqiCategory: 'Good',
      aqiColor: AppColors.statusSuccess,
      generalRecommendation:
          'Air quality is satisfactory and poses little or no risk to general health.',
      pollutants: [
        AqiPollutant(
          name: 'PM2.5',
          value: 25.0,
          unit: 'µg/m³',
          status: 'Good',
          statusColor: AppColors.statusSuccess,
        ),
        AqiPollutant(
          name: 'PM10',
          value: 43.0,
          unit: 'µg/m³',
          status: 'Moderate',
          statusColor: AppColors.statusWarning,
        ),
        AqiPollutant(
          name: 'NO2',
          value: 32.0,
          unit: 'µg/m³',
          status: 'Good',
          statusColor: AppColors.statusSuccess,
        ),
        AqiPollutant(
          name: 'O3',
          value: 12.0,
          unit: 'µg/m³',
          status: 'Good',
          statusColor: AppColors.statusSuccess,
        ),
      ],
      pollenLevels: [
        PollenItem(
          type: 'Tree Pollen',
          level: 'Low',
          count: 14,
          levelColor: AppColors.statusSuccess,
        ),
        PollenItem(
          type: 'Grass Pollen',
          level: 'Moderate',
          count: 48,
          levelColor: AppColors.statusWarning,
        ),
        PollenItem(
          type: 'Weed Pollen',
          level: 'Low',
          count: 8,
          levelColor: AppColors.statusSuccess,
        ),
      ],
      uvIndex: 5,
      uvCategory: 'Moderate',
      uvAdvice:
          'Wear sunglasses and apply SPF 30+ if outdoors between 11 AM - 3 PM.',
      humidity: 68,
      humidityImpact: 'Slightly sticky but comfortable for ventilation.',
      environmentalRisk: 'Low Risk',
      sensitiveGroupAdvisories: [
        'Asthma patients: Safe for regular outdoor exertion.',
        'Children & elderly: No restrictions today.',
      ],
      isMockData: true, // Clearly marked per requirement
    );
  }
}
