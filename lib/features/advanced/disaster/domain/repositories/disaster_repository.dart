import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/disaster_model.dart';

abstract class DisasterRepository {
  Future<List<DisasterAlert>> getActiveDisasters();
  Future<DisasterAlert?> getDisasterById(String id);
}

class MockDisasterRepository implements DisasterRepository {
  final List<DisasterAlert> _alerts = [
    DisasterAlert(
      id: 'disaster-cyclone-1',
      title: 'Cyclonic Storm Advisory (Bay of Bengal)',
      type: DisasterType.cyclone,
      severity: DisasterSeverity.high,
      affectedRegion: 'Coastal Odisha, West Bengal & Northern Andhra Pradesh',
      description:
          'Deep Depression over Bay of Bengal intensified into Cyclonic Storm moving NW with wind speeds 80–95 km/h.',
      startTime: DateTime.now().subtract(const Duration(hours: 6)),
      endTime: DateTime.now().add(const Duration(hours: 36)),
      whatToDo: [
        'Stay indoors away from windows and glass doors',
        'Keep emergency radio, flashlight, and extra batteries ready',
        'Store adequate clean drinking water and non-perishable food',
        'Follow instructions from official disaster response agencies'
      ],
      whatToAvoid: [
        'Do not venture near sea coasts, river banks, or low-lying areas',
        'Avoid standing near power lines, trees, or loose structures',
        'Do not spread unverified rumors on social media'
      ],
      preparednessChecklist: [
        'Emergency First Aid kit verified',
        'Mobile devices fully charged with power banks',
        'Important documents kept in waterproof pouch',
        'Vehicle fuel tank topped up'
      ],
      source: 'National Disaster Management Authority / IMD',
      lastUpdated: DateTime.now(),
    ),
    DisasterAlert(
      id: 'disaster-heatwave-1',
      title: 'Extreme Heatwave Warning',
      type: DisasterType.heatwave,
      severity: DisasterSeverity.moderate,
      affectedRegion: 'North & Western Plains (Delhi, Rajasthan, MP)',
      description:
          'Day temperatures expected to cross 44°C with dry warm winds during 12 PM - 4 PM.',
      startTime: DateTime.now().subtract(const Duration(hours: 12)),
      endTime: DateTime.now().add(const Duration(hours: 48)),
      whatToDo: [
        'Drink plenty of ORS, water, buttermilk, and coconut water',
        'Wear lightweight, light-colored cotton clothing',
        'Use sunglasses, umbrella, or hat when going outdoors'
      ],
      whatToAvoid: [
        'Avoid strenuous outdoor work between 12:00 PM and 4:00 PM',
        'Avoid alcoholic beverages and excessive caffeine'
      ],
      preparednessChecklist: [
        'Hydration supplies ready',
        'Cool indoor shading checked'
      ],
      source: 'State Disaster Management Authority',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    DisasterAlert(
      id: 'disaster-lightning-1',
      title: 'Severe Lightning & Thunderstorm Alert',
      type: DisasterType.lightning,
      severity: DisasterSeverity.high,
      affectedRegion: 'Central & Eastern Chota Nagpur Plateau',
      description:
          'Frequent cloud-to-ground lightning strikes detected in active storm clusters.',
      startTime: DateTime.now().subtract(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 4)),
      whatToDo: [
        'Seek immediate shelter in a robust closed building',
        'Unplug sensitive electronic appliances'
      ],
      whatToAvoid: [
        'Never take shelter under tall isolated trees or metal towers',
        'Avoid open fields, hilltops, and water bodies'
      ],
      preparednessChecklist: [
        'Stay indoors during thunderstorm sound',
        'Keep emergency contacts handy'
      ],
      source: 'Lightning Monitoring Network',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  @override
  Future<List<DisasterAlert>> getActiveDisasters() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _alerts;
  }

  @override
  Future<DisasterAlert?> getDisasterById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _alerts.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}

final disasterRepositoryProvider = Provider<DisasterRepository>((ref) {
  return MockDisasterRepository();
});

final activeDisastersProvider =
    FutureProvider<List<DisasterAlert>>((ref) async {
  final repo = ref.watch(disasterRepositoryProvider);
  return repo.getActiveDisasters();
});
