import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/location_model.dart';
import '../../domain/repositories/location_repository.dart';
import '../../data/repositories/mock_location_repository.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return MockLocationRepository();
});

class LocationState {
  final LocationModel selectedLocation;
  final List<LocationModel> savedLocations;
  final List<LocationModel> searchResults;
  final List<LocationModel> popularCities;
  final bool isSearching;
  final bool isLoading;

  const LocationState({
    required this.selectedLocation,
    this.savedLocations = const [],
    this.searchResults = const [],
    this.popularCities = const [],
    this.isSearching = false,
    this.isLoading = false,
  });

  LocationState copyWith({
    LocationModel? selectedLocation,
    List<LocationModel>? savedLocations,
    List<LocationModel>? searchResults,
    List<LocationModel>? popularCities,
    bool? isSearching,
    bool? isLoading,
  }) {
    return LocationState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      savedLocations: savedLocations ?? this.savedLocations,
      searchResults: searchResults ?? this.searchResults,
      popularCities: popularCities ?? this.popularCities,
      isSearching: isSearching ?? this.isSearching,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  final LocationRepository _repository;

  LocationNotifier(this._repository)
      : super(
          const LocationState(
            selectedLocation: LocationModel(
              id: 'loc-home',
              name: 'Lucknow',
              state: 'Uttar Pradesh',
              country: 'India',
              lat: 26.8467,
              lon: 80.9462,
              category: LocationCategory.home,
              currentTemp: 29.0,
              currentCondition: 'Partly Cloudy',
            ),
          ),
        ) {
    loadLocations();
  }

  Future<void> loadLocations() async {
    state = state.copyWith(isLoading: true);
    final saved = await _repository.getSavedLocations();
    final popular = await _repository.getPopularCities();
    state = state.copyWith(
      savedLocations: saved,
      popularCities: popular,
      isLoading: false,
    );
  }

  void selectLocation(LocationModel location) {
    state = state.copyWith(selectedLocation: location);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchResults: [], isSearching: false);
      return;
    }
    state = state.copyWith(isSearching: true);
    final results = await _repository.searchLocations(query);
    state = state.copyWith(searchResults: results, isSearching: false);
  }

  Future<void> addSavedLocation(LocationModel location) async {
    await _repository.saveLocation(location);
    await loadLocations();
  }

  Future<void> removeLocation(String id) async {
    await _repository.removeSavedLocation(id);
    await loadLocations();
  }

  Future<void> updateCategory(String id, LocationCategory category) async {
    await _repository.updateLocationCategory(id, category);
    await loadLocations();
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  final repo = ref.watch(locationRepositoryProvider);
  return LocationNotifier(repo);
});
