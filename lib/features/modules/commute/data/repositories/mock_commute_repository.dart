import '../../domain/models/commute_models.dart';

class MockCommuteRepository {
  Future<CommuteData> getCommuteData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const CommuteData(
      activeRoute: CommuteSegment(
        title: 'Home → College / Work',
        origin: 'Indira Nagar, Lucknow',
        destination: 'IIIT Lucknow / IT City',
        trafficStatus: 'Moderate',
        rainChance: 40,
        visibilityKm: 6.0,
        windSpeed: 10.0,
        conditionSummary: 'Moderate Conditions',
        fogWarning: null,
      ),
      savedRoutes: [
        CommuteSegment(
          title: 'Home → Airport',
          origin: 'Gomti Nagar',
          destination: 'Chaudhary Charan Singh Airport (LKO)',
          trafficStatus: 'Smooth',
          rainChance: 20,
          visibilityKm: 8.0,
          windSpeed: 12.0,
          conditionSummary: 'Clear Driving',
        ),
        CommuteSegment(
          title: 'Lucknow → Kanpur Highway',
          origin: 'Transport Nagar',
          destination: 'Kanpur Bypass',
          trafficStatus: 'Heavy',
          rainChance: 60,
          visibilityKm: 4.5,
          windSpeed: 16.0,
          conditionSummary: 'Wet Asphalt & Slow Traffic',
        ),
      ],
      overallAdvice:
          'Drive with standard caution. Low probability of sudden showers around 5:30 PM.',
    );
  }
}
