import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../health/data/repositories/mock_health_repository.dart';
import '../../health/domain/models/health_models.dart';
import '../../fitness/data/repositories/mock_fitness_repository.dart';
import '../../fitness/domain/models/fitness_models.dart';
import '../../marine/data/repositories/mock_marine_repository.dart';
import '../../marine/domain/models/marine_models.dart';
import '../../travel/data/repositories/mock_travel_repository.dart';
import '../../travel/domain/models/travel_models.dart';
import '../../family/data/repositories/mock_family_repository.dart';
import '../../family/domain/models/family_models.dart';
import '../../agriculture/data/repositories/mock_agriculture_repository.dart';
import '../../agriculture/domain/models/agriculture_models.dart';
import '../../commute/data/repositories/mock_commute_repository.dart';
import '../../commute/domain/models/commute_models.dart';
import '../../events/data/repositories/mock_event_repository.dart';
import '../../events/domain/models/event_models.dart';

// Health
final healthRepositoryProvider = Provider((ref) => MockHealthRepository());
final healthDataProvider = FutureProvider<HealthData>((ref) async {
  final loc = ref.watch(locationProvider).selectedLocation;
  final repo = ref.watch(healthRepositoryProvider);
  return repo.getHealthData(loc.name);
});

// Fitness
final fitnessRepositoryProvider = Provider((ref) => MockFitnessRepository());
final fitnessDataProvider = FutureProvider<FitnessData>((ref) async {
  final loc = ref.watch(locationProvider).selectedLocation;
  final repo = ref.watch(fitnessRepositoryProvider);
  return repo.getFitnessData(loc.name);
});

// Marine
final marineRepositoryProvider = Provider((ref) => MockMarineRepository());
final marineDataProvider = FutureProvider<MarineData>((ref) async {
  final loc = ref.watch(locationProvider).selectedLocation;
  final repo = ref.watch(marineRepositoryProvider);
  return repo.getMarineData(loc.name);
});

// Travel
final travelRepositoryProvider = Provider((ref) => MockTravelRepository());
final travelDataProvider = FutureProvider<TravelData>((ref) async {
  final repo = ref.watch(travelRepositoryProvider);
  return repo.getTravelData();
});

// Family
final familyRepositoryProvider = Provider((ref) => MockFamilyRepository());
final familyDataProvider = FutureProvider<FamilyData>((ref) async {
  final repo = ref.watch(familyRepositoryProvider);
  return repo.getFamilyData();
});

// Agriculture
final agricultureRepositoryProvider =
    Provider((ref) => MockAgricultureRepository());
final agricultureDataProvider = FutureProvider<AgricultureData>((ref) async {
  final loc = ref.watch(locationProvider).selectedLocation;
  final repo = ref.watch(agricultureRepositoryProvider);
  return repo.getAgricultureData(loc.name);
});

// Commute
final commuteRepositoryProvider = Provider((ref) => MockCommuteRepository());
final commuteDataProvider = FutureProvider<CommuteData>((ref) async {
  final repo = ref.watch(commuteRepositoryProvider);
  return repo.getCommuteData();
});

// Events
final eventPlannerRepositoryProvider = Provider((ref) => MockEventRepository());
final eventPlannerDataProvider =
    FutureProvider<EventPlannerData>((ref) async {
  final repo = ref.watch(eventPlannerRepositoryProvider);
  return repo.getEventPlannerData();
});
