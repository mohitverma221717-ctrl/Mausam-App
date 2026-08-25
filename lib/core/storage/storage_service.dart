import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// StorageService encapsulating SharedPreferences and SecureStorage
class StorageService {
  static late SharedPreferences _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Preference Keys
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyIsAuthenticated = 'is_authenticated';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyTemperatureUnit = 'unit_temp';
  static const String keyWindUnit = 'unit_wind';
  static const String keyPressureUnit = 'unit_pressure';
  static const String keyDistanceUnit = 'unit_dist';
  static const String keyTimeFormat = 'unit_time';
  static const String keyUserInterests = 'user_interests';
  static const String keySelectedLocation = 'selected_location';
  static const String keySavedLocations = 'saved_locations';

  // Secure Keys
  static const String secureAuthToken = 'auth_token';
  static const String secureRefreshToken = 'refresh_token';
  static const String secureUserId = 'user_id';

  // Synchronous / Async Getters & Setters
  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  static Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static List<String> getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  // Secure Storage Methods
  static Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }
}
