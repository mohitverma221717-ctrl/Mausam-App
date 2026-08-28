import '../models/weather_data.dart';
import '../../../location/domain/models/location_model.dart';

abstract class WeatherRepository {
  Future<WeatherData> getCurrentWeather(LocationModel location);
  Future<List<HourlyForecast>> getHourlyForecast(LocationModel location);
  Future<List<DailyForecast>> getDailyForecast(LocationModel location);
  Future<List<DailyForecast>> getExtendedForecast(LocationModel location);
}
