import '../../domain/models/agriculture_models.dart';

class MockAgricultureRepository {
  Future<AgricultureData> getAgricultureData(String locationName) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const AgricultureData(
      rainForecastDays: 72,
      soilMoisturePercent: 42,
      soilStatus: 'Adequate Moisture',
      farmTemp: 28.0,
      farmHumidity: 65,
      frostRisk: 'Low',
      plantingAdvice:
          'Favorable soil moisture and temperature for wheat sowing, field plowing, and seasonal crop fertilization.',
      isSensorConnected: true,
      crops: [
        CropGuidance(
          cropName: 'Wheat (गेहूं)',
          stage: 'Sowing Preparation',
          guidance:
              'Favorable seedbed temperature (20-25°C). Ensure shallow furrow seeding.',
          risk: 'Low Frost Risk',
        ),
        CropGuidance(
          cropName: 'Mustard (सरसों)',
          stage: 'Vegetative Growth',
          guidance:
              'Optimal soil moisture. Good timing for first light irrigation if dry.',
          risk: 'Monitor for aphid infestation in humid mornings',
        ),
        CropGuidance(
          cropName: 'Sugarcane (गन्ना)',
          stage: 'Maturation',
          guidance:
              'Adequate rainfall forecast ensures steady cane elongation.',
          risk: 'Low Risk',
        ),
      ],
    );
  }
}
