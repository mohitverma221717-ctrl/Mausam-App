import '../../domain/models/fitness_models.dart';
import '../../../../../core/theme/app_colors.dart';

class MockFitnessRepository {
  Future<FitnessData> getFitnessData(String locationName) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const FitnessData(
      bestRunningHours: '6:00 AM – 8:00 AM',
      overallSuitability: 'Good Conditions',
      activitySuggestion:
          'Perfect time for running, cycling, and outdoor workouts.',
      heatIndex: 31.0,
      heatRisk: 'Low Risk',
      uvIndex: 5,
      windSpeed: 12.0,
      humidity: 68,
      currentTemp: 26.0,
      hourlyWindows: [
        RunningWindow(
          timeRange: '5:00 AM – 6:00 AM',
          quality: 'Optimal',
          qualityColor: AppColors.statusSuccess,
          temp: 24,
          humidity: 75,
          wind: 8,
          note: 'Cool breezes and low traffic.',
        ),
        RunningWindow(
          timeRange: '6:00 AM – 8:00 AM',
          quality: 'Optimal',
          qualityColor: AppColors.statusSuccess,
          temp: 26,
          humidity: 68,
          wind: 12,
          note: 'Best daylight window with moderate UV.',
        ),
        RunningWindow(
          timeRange: '8:00 AM – 10:00 AM',
          quality: 'Fair',
          qualityColor: AppColors.statusWarning,
          temp: 29,
          humidity: 60,
          wind: 14,
          note: 'Rising temperature and sun intensity.',
        ),
        RunningWindow(
          timeRange: '6:00 PM – 8:00 PM',
          quality: 'Good',
          qualityColor: AppColors.statusSuccess,
          temp: 28,
          humidity: 64,
          wind: 10,
          note: 'Pleasant dusk setting with low UV index.',
        ),
      ],
      activityRatings: {
        'Running': 'Optimal',
        'Cycling': 'Good',
        'Yoga Outdoors': 'Optimal',
        'HIIT / Cardio': 'Good',
      },
    );
  }
}
