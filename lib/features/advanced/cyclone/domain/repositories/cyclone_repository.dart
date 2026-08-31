import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cyclone_model.dart';

abstract class CycloneRepository {
  Future<List<Cyclone>> getActiveCyclones();
  Future<Cyclone?> getCycloneById(String id);
}

class MockCycloneRepository implements CycloneRepository {
  final List<Cyclone> _cyclones = [
    Cyclone(
      id: 'cyclone-remal-2026',
      name: 'Cyclone REMAL',
      oceanBasin: 'North Indian Ocean (Bay of Bengal)',
      category: 'Severe Cyclonic Storm',
      currentPosition: CyclonePosition(
        latitude: 19.8,
        longitude: 88.4,
        timestamp: DateTime.now(),
        windSpeedKmh: 110,
        pressureHpa: 984,
      ),
      observedTrack: [
        CyclonePosition(
          latitude: 15.2,
          longitude: 87.0,
          timestamp: DateTime.now().subtract(const Duration(hours: 36)),
          windSpeedKmh: 65,
          pressureHpa: 998,
        ),
        CyclonePosition(
          latitude: 17.4,
          longitude: 87.8,
          timestamp: DateTime.now().subtract(const Duration(hours: 18)),
          windSpeedKmh: 90,
          pressureHpa: 990,
        ),
        CyclonePosition(
          latitude: 19.8,
          longitude: 88.4,
          timestamp: DateTime.now(),
          windSpeedKmh: 110,
          pressureHpa: 984,
        ),
      ],
      forecastPath: [
        CycloneForecastPoint(
          latitude: 21.5,
          longitude: 89.1,
          timestamp: DateTime.now().add(const Duration(hours: 12)),
          expectedWindSpeedKmh: 120,
          intensityCategory: 'Severe Cyclonic Storm',
        ),
        CycloneForecastPoint(
          latitude: 22.8,
          longitude: 89.8,
          timestamp: DateTime.now().add(const Duration(hours: 24)),
          expectedWindSpeedKmh: 100,
          intensityCategory: 'Landfall Phase',
        ),
        CycloneForecastPoint(
          latitude: 24.2,
          longitude: 90.5,
          timestamp: DateTime.now().add(const Duration(hours: 36)),
          expectedWindSpeedKmh: 60,
          intensityCategory: 'Deep Depression',
        ),
      ],
      movementDirection: 'North-Northeast (NNE)',
      movementSpeedKmh: 16.5,
      expectedLandfallTime: 'Tomorrow, 5:30 PM IST',
      expectedLandfallLocation: 'Near Sagar Island & Khepupara Coast',
      affectedRegions: [
        'Sundarbans Coastal Belt',
        'Odisha North Coast (Bhadrak, Balasore)',
        'West Bengal (South 24 Parganas, East Medinipur)',
        'Southern Bangladesh'
      ],
      source: 'IMD RSMC Tropical Cyclone Bulletin',
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  Future<List<Cyclone>> getActiveCyclones() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _cyclones;
  }

  @override
  Future<Cyclone?> getCycloneById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _cyclones.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

final cycloneRepositoryProvider = Provider<CycloneRepository>((ref) {
  return MockCycloneRepository();
});

final activeCyclonesProvider = FutureProvider<List<Cyclone>>((ref) async {
  final repo = ref.watch(cycloneRepositoryProvider);
  return repo.getActiveCyclones();
});
