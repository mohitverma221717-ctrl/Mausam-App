import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nowcast_model.dart';

abstract class NowcastRepository {
  Future<NowcastData?> getNowcastData(double lat, double lon);
}

class MockNowcastRepository implements NowcastRepository {
  @override
  Future<NowcastData?> getNowcastData(double lat, double lon) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return NowcastData(
      isRainExpectedSoon: true,
      rainWindowText: 'Rain may reach this area within the next 30–45 minutes.',
      shortTermTrend: 'Increasing Intensity',
      rainProbability: 85,
      intensityCategory: 'Moderate Rain',
      timeline: const [
        NowcastTimelineStep(
            minutesOffset: 'Now', status: 'Partly Cloudy', rainAmountMm: 0.0),
        NowcastTimelineStep(
            minutesOffset: '+15 min',
            status: 'Light Drizzle',
            rainAmountMm: 0.4),
        NowcastTimelineStep(
            minutesOffset: '+30 min',
            status: 'Moderate Rain',
            rainAmountMm: 2.1),
        NowcastTimelineStep(
            minutesOffset: '+45 min',
            status: 'Moderate Rain',
            rainAmountMm: 3.5),
        NowcastTimelineStep(
            minutesOffset: '+60 min',
            status: 'Passing Shower',
            rainAmountMm: 1.2),
      ],
      source: 'High-Resolution Rapid Refresh (HRRR) Nowcast Engine',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
    );
  }
}

final nowcastRepositoryProvider = Provider<NowcastRepository>((ref) {
  return MockNowcastRepository();
});

final nowcastDataProvider = FutureProvider<NowcastData?>((ref) async {
  final repo = ref.watch(nowcastRepositoryProvider);
  return repo.getNowcastData(28.6139, 77.2090);
});
