import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/earthquake_event.dart';

abstract class EarthquakeRepository {
  Future<List<EarthquakeEvent>> getRecentEarthquakes();
}

class MockEarthquakeRepository implements EarthquakeRepository {
  final List<EarthquakeEvent> _events = [
    EarthquakeEvent(
      id: 'usgs-eq-2026-001',
      magnitude: 6.2,
      latitude: 28.1,
      longitude: 84.6,
      depthKm: 12.5,
      place: '78 km NW of Kathmandu, Nepal',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: 'USGS Seismic Network',
      distanceKm: 420.0,
    ),
    EarthquakeEvent(
      id: 'usgs-eq-2026-002',
      magnitude: 4.8,
      latitude: 34.2,
      longitude: 74.8,
      depthKm: 35.0,
      place: '45 km E of Srinagar, Jammu & Kashmir',
      timestamp: DateTime.now().subtract(const Duration(hours: 14)),
      source: 'National Centre for Seismology (NCS)',
      distanceKm: 610.0,
    ),
    EarthquakeEvent(
      id: 'usgs-eq-2026-003',
      magnitude: 5.4,
      latitude: 24.8,
      longitude: 93.9,
      depthKm: 48.0,
      place: '32 km S of Imphal, Manipur',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      source: 'USGS / NCS',
      distanceKm: 980.0,
    ),
    EarthquakeEvent(
      id: 'usgs-eq-2026-004',
      magnitude: 3.6,
      latitude: 30.3,
      longitude: 78.0,
      depthKm: 10.0,
      place: '18 km NE of Dehradun, Uttarakhand',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      source: 'National Centre for Seismology',
      distanceKm: 210.0,
    ),
  ];

  @override
  Future<List<EarthquakeEvent>> getRecentEarthquakes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _events;
  }
}

final earthquakeRepositoryProvider = Provider<EarthquakeRepository>((ref) {
  return MockEarthquakeRepository();
});

final recentEarthquakesProvider =
    FutureProvider<List<EarthquakeEvent>>((ref) async {
  final repo = ref.watch(earthquakeRepositoryProvider);
  return repo.getRecentEarthquakes();
});
