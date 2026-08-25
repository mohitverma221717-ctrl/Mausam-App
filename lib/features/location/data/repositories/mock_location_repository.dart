import '../../domain/models/location_model.dart';
import '../../domain/repositories/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  final List<LocationModel> _savedLocations = [
    const LocationModel(
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
    const LocationModel(
      id: 'loc-college',
      name: 'Kanpur',
      state: 'Uttar Pradesh',
      country: 'India',
      lat: 26.4499,
      lon: 80.3319,
      category: LocationCategory.college,
      currentTemp: 28.0,
      currentCondition: 'Partly Cloudy',
    ),
    const LocationModel(
      id: 'loc-work',
      name: 'Delhi',
      state: 'Delhi',
      country: 'India',
      lat: 28.6139,
      lon: 77.2090,
      category: LocationCategory.work,
      currentTemp: 30.0,
      currentCondition: 'Sunny',
    ),
    const LocationModel(
      id: 'loc-travel-1',
      name: 'Mumbai',
      state: 'Maharashtra',
      country: 'India',
      lat: 19.0760,
      lon: 72.8777,
      category: LocationCategory.travel,
      currentTemp: 28.0,
      currentCondition: 'Humid & Rain',
    ),
    const LocationModel(
      id: 'loc-travel-2',
      name: 'London',
      state: 'England',
      country: 'United Kingdom',
      lat: 51.5074,
      lon: -0.1278,
      category: LocationCategory.travel,
      currentTemp: 18.0,
      currentCondition: 'Rain Likely',
    ),
  ];

  final List<LocationModel> _popularCities = const [
    LocationModel(
      id: 'pop-1',
      name: 'Delhi',
      state: 'Delhi',
      country: 'India',
      lat: 28.6139,
      lon: 77.2090,
      currentTemp: 30.0,
      currentCondition: 'Sunny',
    ),
    LocationModel(
      id: 'pop-2',
      name: 'Mumbai',
      state: 'Maharashtra',
      country: 'India',
      lat: 19.0760,
      lon: 72.8777,
      currentTemp: 28.0,
      currentCondition: 'Rain',
    ),
    LocationModel(
      id: 'pop-3',
      name: 'Bengaluru',
      state: 'Karnataka',
      country: 'India',
      lat: 12.9716,
      lon: 77.5946,
      currentTemp: 24.0,
      currentCondition: 'Pleasant',
    ),
    LocationModel(
      id: 'pop-4',
      name: 'Chennai',
      state: 'Tamil Nadu',
      country: 'India',
      lat: 13.0827,
      lon: 80.2707,
      currentTemp: 32.0,
      currentCondition: 'Sunny',
    ),
    LocationModel(
      id: 'pop-5',
      name: 'Hyderabad',
      state: 'Telangana',
      country: 'India',
      lat: 17.3850,
      lon: 78.4867,
      currentTemp: 29.0,
      currentCondition: 'Partly Cloudy',
    ),
  ];

  @override
  Future<LocationModel> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const LocationModel(
      id: 'current-gps',
      name: 'Lucknow',
      state: 'Uttar Pradesh',
      country: 'India',
      lat: 26.8467,
      lon: 80.9462,
      isCurrentLocation: true,
      category: LocationCategory.current,
      currentTemp: 29.0,
      currentCondition: 'Partly Cloudy',
    );
  }

  @override
  Future<List<LocationModel>> searchLocations(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.trim().isEmpty) return getRecentLocations();

    final q = query.toLowerCase();
    final all = [..._savedLocations, ..._popularCities];
    final results = all
        .where((l) =>
            l.name.toLowerCase().contains(q) ||
            l.state.toLowerCase().contains(q) ||
            l.country.toLowerCase().contains(q))
        .toList();

    if (results.isEmpty) {
      // Dynamic fallback search result
      results.add(
        LocationModel(
          id: 'custom-${query.hashCode}',
          name: query.substring(0, 1).toUpperCase() + query.substring(1),
          state: 'Region',
          country: 'India',
          lat: 26.0,
          lon: 80.0,
          currentTemp: 27.0,
          currentCondition: 'Clear',
        ),
      );
    }
    return results;
  }

  @override
  Future<List<LocationModel>> getRecentLocations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _savedLocations.take(4).toList();
  }

  @override
  Future<List<LocationModel>> getPopularCities() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _popularCities;
  }

  @override
  Future<List<LocationModel>> getSavedLocations() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _savedLocations;
  }

  @override
  Future<void> saveLocation(LocationModel location) async {
    final idx = _savedLocations.indexWhere((l) => l.id == location.id);
    if (idx >= 0) {
      _savedLocations[idx] = location;
    } else {
      _savedLocations.add(location);
    }
  }

  @override
  Future<void> removeSavedLocation(String id) async {
    _savedLocations.removeWhere((l) => l.id == id);
  }

  @override
  Future<void> updateLocationCategory(
      String id, LocationCategory category) async {
    final idx = _savedLocations.indexWhere((l) => l.id == id);
    if (idx >= 0) {
      _savedLocations[idx] = _savedLocations[idx].copyWith(category: category);
    }
  }
}
