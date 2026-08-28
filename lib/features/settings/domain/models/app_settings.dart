enum TemperatureUnit { celsius, fahrenheit }

enum WindUnit { kmh, mph }

enum PressureUnit { hpa, inHg }

enum DistanceUnit { km, miles }

enum TimeFormat { format12h, format24h }

enum AppThemeMode { dark, light, system }

enum AppLanguage { english, hindi }

class AppSettings {
  final TemperatureUnit temperatureUnit;
  final WindUnit windUnit;
  final PressureUnit pressureUnit;
  final DistanceUnit distanceUnit;
  final TimeFormat timeFormat;
  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool weatherAlerts;
  final bool rainAlerts;
  final bool severeWeatherAlerts;
  final bool dailySummary;
  final bool healthAlerts;
  final bool travelAlerts;
  final bool commuteAlerts;

  const AppSettings({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windUnit = WindUnit.kmh,
    this.pressureUnit = PressureUnit.hpa,
    this.distanceUnit = DistanceUnit.km,
    this.timeFormat = TimeFormat.format12h,
    this.themeMode = AppThemeMode.dark,
    this.language = AppLanguage.english,
    this.weatherAlerts = true,
    this.rainAlerts = true,
    this.severeWeatherAlerts = true,
    this.dailySummary = true,
    this.healthAlerts = true,
    this.travelAlerts = false,
    this.commuteAlerts = true,
  });

  AppSettings copyWith({
    TemperatureUnit? temperatureUnit,
    WindUnit? windUnit,
    PressureUnit? pressureUnit,
    DistanceUnit? distanceUnit,
    TimeFormat? timeFormat,
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? weatherAlerts,
    bool? rainAlerts,
    bool? severeWeatherAlerts,
    bool? dailySummary,
    bool? healthAlerts,
    bool? travelAlerts,
    bool? commuteAlerts,
  }) {
    return AppSettings(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windUnit: windUnit ?? this.windUnit,
      pressureUnit: pressureUnit ?? this.pressureUnit,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      timeFormat: timeFormat ?? this.timeFormat,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      weatherAlerts: weatherAlerts ?? this.weatherAlerts,
      rainAlerts: rainAlerts ?? this.rainAlerts,
      severeWeatherAlerts: severeWeatherAlerts ?? this.severeWeatherAlerts,
      dailySummary: dailySummary ?? this.dailySummary,
      healthAlerts: healthAlerts ?? this.healthAlerts,
      travelAlerts: travelAlerts ?? this.travelAlerts,
      commuteAlerts: commuteAlerts ?? this.commuteAlerts,
    );
  }
}
