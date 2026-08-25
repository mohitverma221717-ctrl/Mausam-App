import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/app_settings.dart';
import '../../../../core/storage/storage_service.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeStr = StorageService.getString(StorageService.keyThemeMode,
        defaultValue: 'dark');
    final langStr = StorageService.getString(StorageService.keyLanguage,
        defaultValue: 'en');
    final tempStr = StorageService.getString(StorageService.keyTemperatureUnit,
        defaultValue: 'celsius');
    final windStr = StorageService.getString(StorageService.keyWindUnit,
        defaultValue: 'kmh');

    state = state.copyWith(
      themeMode: themeStr == 'light'
          ? AppThemeMode.light
          : themeStr == 'system'
              ? AppThemeMode.system
              : AppThemeMode.dark,
      language: langStr == 'hi' ? AppLanguage.hindi : AppLanguage.english,
      temperatureUnit: tempStr == 'fahrenheit'
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius,
      windUnit: windStr == 'mph' ? WindUnit.mph : WindUnit.kmh,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await StorageService.setString(StorageService.keyThemeMode, mode.name);
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await StorageService.setString(
      StorageService.keyLanguage,
      language == AppLanguage.hindi ? 'hi' : 'en',
    );
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    state = state.copyWith(temperatureUnit: unit);
    await StorageService.setString(
        StorageService.keyTemperatureUnit, unit.name);
  }

  Future<void> setWindUnit(WindUnit unit) async {
    state = state.copyWith(windUnit: unit);
    await StorageService.setString(StorageService.keyWindUnit, unit.name);
  }

  Future<void> setPressureUnit(PressureUnit unit) async {
    state = state.copyWith(pressureUnit: unit);
  }

  Future<void> setDistanceUnit(DistanceUnit unit) async {
    state = state.copyWith(distanceUnit: unit);
  }

  Future<void> setTimeFormat(TimeFormat format) async {
    state = state.copyWith(timeFormat: format);
  }

  void toggleNotification(String type, bool value) {
    switch (type) {
      case 'weatherAlerts':
        state = state.copyWith(weatherAlerts: value);
        break;
      case 'rainAlerts':
        state = state.copyWith(rainAlerts: value);
        break;
      case 'severeWeatherAlerts':
        state = state.copyWith(severeWeatherAlerts: value);
        break;
      case 'dailySummary':
        state = state.copyWith(dailySummary: value);
        break;
      case 'healthAlerts':
        state = state.copyWith(healthAlerts: value);
        break;
      case 'travelAlerts':
        state = state.copyWith(travelAlerts: value);
        break;
      case 'commuteAlerts':
        state = state.copyWith(commuteAlerts: value);
        break;
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

final currentLocaleProvider = Provider<Locale>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.language == AppLanguage.hindi
      ? const Locale('hi')
      : const Locale('en');
});

final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsProvider);
  switch (settings.themeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});
