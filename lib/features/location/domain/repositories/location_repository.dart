import '../models/location_model.dart';

abstract class LocationRepository {
  Future<LocationModel> getCurrentLocation();
  Future<List<LocationModel>> searchLocations(String query);
  Future<List<LocationModel>> getRecentLocations();
  Future<List<LocationModel>> getPopularCities();
  Future<List<LocationModel>> getSavedLocations();
  Future<void> saveLocation(LocationModel location);
  Future<void> removeSavedLocation(String id);
  Future<void> updateLocationCategory(String id, LocationCategory category);
}
