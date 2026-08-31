import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lightning_model.dart';

abstract class LightningRepository {
  Future<LightningActivity> getLightningActivity(double lat, double lon);
}

class MockLightningRepository implements LightningRepository {
  @override
  Future<LightningActivity> getLightningActivity(double lat, double lon) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return LightningActivity(
      location: 'Current Region (Within 50 km)',
      strikeCountLastHour: 142,
      nearestStrikeKm: 6.4,
      densityLevel: 'High',
      activeStormCells: 3,
      lastStrikeTimestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      source: 'Blitzortung Lightning Telemetry Network',
    );
  }
}

final lightningRepositoryProvider = Provider<LightningRepository>((ref) {
  return MockLightningRepository();
});

final lightningActivityProvider =
    FutureProvider<LightningActivity>((ref) async {
  final repo = ref.watch(lightningRepositoryProvider);
  return repo.getLightningActivity(28.6139, 77.2090);
});
