import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../data/repositories/mock_weather_repository.dart';
import '../../../location/presentation/providers/location_provider.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return MockWeatherRepository();
});

class WeatherState {
  final bool isLoading;
  final bool isRefreshing;
  final WeatherData? currentWeather;
  final List<HourlyForecast> hourlyForecast;
  final List<DailyForecast> dailyForecast;
  final List<DailyForecast> extendedForecast;
  final String? errorMessage;
  final bool isOffline;

  const WeatherState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.currentWeather,
    this.hourlyForecast = const [],
    this.dailyForecast = const [],
    this.extendedForecast = const [],
    this.errorMessage,
    this.isOffline = false,
  });

  WeatherState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    WeatherData? currentWeather,
    List<HourlyForecast>? hourlyForecast,
    List<DailyForecast>? dailyForecast,
    List<DailyForecast>? extendedForecast,
    String? errorMessage,
    bool? isOffline,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentWeather: currentWeather ?? this.currentWeather,
      hourlyForecast: hourlyForecast ?? this.hourlyForecast,
      dailyForecast: dailyForecast ?? this.dailyForecast,
      extendedForecast: extendedForecast ?? this.extendedForecast,
      errorMessage: errorMessage,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository _repository;
  final Ref _ref;

  WeatherNotifier(this._repository, this._ref) : super(const WeatherState()) {
    _init();
  }

  void _init() {
    _ref.listen(locationProvider.select((s) => s.selectedLocation),
        (previous, next) {
      fetchWeather();
    });
    fetchWeather();
  }

  Future<void> fetchWeather({bool isRefresh = false}) async {
    final location = _ref.read(locationProvider).selectedLocation;
    state = state.copyWith(
      isLoading: !isRefresh,
      isRefreshing: isRefresh,
      errorMessage: null,
    );

    try {
      final current = await _repository.getCurrentWeather(location);
      final hourly = await _repository.getHourlyForecast(location);
      final daily = await _repository.getDailyForecast(location);
      final extended = await _repository.getExtendedForecast(location);

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        currentWeather: current,
        hourlyForecast: hourly,
        dailyForecast: daily,
        extendedForecast: extended,
        isOffline: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage:
            'Unable to fetch weather data. Please check your connection.',
        isOffline: true,
      );
    }
  }
}

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final repo = ref.watch(weatherRepositoryProvider);
  return WeatherNotifier(repo, ref);
});
