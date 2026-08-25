class CropGuidance {
  final String cropName; // "Wheat / धान", "Mustard", "Sugarcane"
  final String stage; // Sowing, Flowering, Harvest
  final String guidance; // "Optimal moisture. Good time for fertilizer spray."
  final String risk; // "Low frost danger"

  const CropGuidance({
    required this.cropName,
    required this.stage,
    required this.guidance,
    required this.risk,
  });
}

class AgricultureData {
  final int rainForecastDays; // 72% chance in next 48 hrs
  final int soilMoisturePercent; // 42%
  final String soilStatus; // "Adequate"
  final double farmTemp; // 28°C
  final int farmHumidity; // 65%
  final String frostRisk; // "Low"
  final String
      plantingAdvice; // "Good time for wheat sowing and soil preparation."
  final List<CropGuidance> crops;
  final bool isSensorConnected; // explicit indicator per specification

  const AgricultureData({
    required this.rainForecastDays,
    required this.soilMoisturePercent,
    required this.soilStatus,
    required this.farmTemp,
    required this.farmHumidity,
    required this.frostRisk,
    required this.plantingAdvice,
    required this.crops,
    this.isSensorConnected = true,
  });
}
