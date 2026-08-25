import '../../domain/models/marine_models.dart';
import '../../../../../core/theme/app_colors.dart';

class MockMarineRepository {
  Future<MarineData> getMarineData(String locationName) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const MarineData(
      seaCondition: 'Good',
      conditionColor: AppColors.statusSuccess,
      waveHeight: 1.2,
      wavePeriodSeconds: 8.5,
      waterTemp: 28.0,
      windSpeedKnots: 18.0,
      windDirection: 'NW',
      swellDirection: 'WSW',
      tides: [
        TideEvent(
          time: '5:30 PM',
          type: 'High Tide',
          heightMeters: 2.6,
          isHigh: true,
        ),
        TideEvent(
          time: '11:20 AM',
          type: 'Low Tide',
          heightMeters: 0.8,
          isHigh: false,
        ),
        TideEvent(
          time: '11:45 PM',
          type: 'Low Tide',
          heightMeters: 0.9,
          isHigh: false,
        ),
      ],
      boatingSafety: 'Safe for small and medium recreational craft.',
      surfQuality: 'Clean 3–4 ft waves with light offshore wind.',
      isMockData: true, // Marked per requirement
    );
  }
}
