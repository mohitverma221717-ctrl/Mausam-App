import '../../domain/models/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../../location/domain/models/location_model.dart';

class MockWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherData> getCurrentWeather(LocationModel location) async {
    // Simulate brief network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Dynamic customization based on city
    final isDelhi = location.name.toLowerCase().contains('delhi');
    final isMumbai = location.name.toLowerCase().contains('mumbai');
    final isLondon = location.name.toLowerCase().contains('london');

    if (isDelhi) {
      return WeatherData(
        cityName: 'Delhi',
        stateName: 'National Capital Region',
        temperature: 32.0,
        feelsLike: 36.0,
        tempMin: 26.0,
        tempMax: 35.0,
        condition: 'Sunny & Hazy',
        conditionType: WeatherConditionType.sunny,
        humidity: 55,
        windSpeed: 10.0,
        windDirection: 'NW',
        pressure: 1009,
        visibility: 5.0,
        uvIndex: 8,
        aqi: 145,
        aqiStatus: 'Moderate',
        cloudCover: 20,
        rainProbability: 10,
        sunrise: '05:55 AM',
        sunset: '06:51 PM',
        lastUpdated: DateTime.now(),
        lat: location.lat,
        lon: location.lon,
      );
    }

    if (isLondon) {
      return WeatherData(
        cityName: 'London',
        stateName: 'United Kingdom',
        temperature: 18.0,
        feelsLike: 17.0,
        tempMin: 14.0,
        tempMax: 21.0,
        condition: 'Rain Likely',
        conditionType: WeatherConditionType.rainy,
        humidity: 78,
        windSpeed: 14.0,
        windDirection: 'SW',
        pressure: 1012,
        visibility: 8.0,
        uvIndex: 3,
        aqi: 32,
        aqiStatus: 'Good',
        cloudCover: 85,
        rainProbability: 70,
        sunrise: '06:04 AM',
        sunset: '08:02 PM',
        lastUpdated: DateTime.now(),
        lat: location.lat,
        lon: location.lon,
      );
    }

    if (isMumbai) {
      return WeatherData(
        cityName: 'Mumbai',
        stateName: 'Maharashtra',
        temperature: 30.0,
        feelsLike: 35.0,
        tempMin: 26.0,
        tempMax: 32.0,
        condition: 'Humid & Partly Cloudy',
        conditionType: WeatherConditionType.partlyCloudy,
        humidity: 82,
        windSpeed: 18.0,
        windDirection: 'W',
        pressure: 1008,
        visibility: 7.0,
        uvIndex: 7,
        aqi: 94,
        aqiStatus: 'Moderate',
        cloudCover: 55,
        rainProbability: 40,
        sunrise: '06:22 AM',
        sunset: '07:01 PM',
        lastUpdated: DateTime.now(),
        lat: location.lat,
        lon: location.lon,
      );
    }

    // Default: Lucknow / UP reference
    return WeatherData(
      cityName: location.name.isNotEmpty ? location.name : 'Lucknow',
      stateName: location.state.isNotEmpty ? location.state : 'Uttar Pradesh',
      temperature: 29.0,
      feelsLike: 31.0,
      tempMin: 24.0,
      tempMax: 34.0,
      condition: 'Partly Cloudy',
      conditionType: WeatherConditionType.partlyCloudy,
      humidity: 68,
      windSpeed: 12.0,
      windDirection: 'ENE',
      pressure: 1012,
      visibility: 6.0,
      uvIndex: 5,
      aqi: 82,
      aqiStatus: 'Good',
      cloudCover: 40,
      rainProbability: 20,
      sunrise: '05:46 AM',
      sunset: '06:28 PM',
      lastUpdated: DateTime.now(),
      lat: location.lat,
      lon: location.lon,
    );
  }

  @override
  Future<List<HourlyForecast>> getHourlyForecast(LocationModel location) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      HourlyForecast(
        time: 'Now',
        temperature: 29,
        condition: 'Partly Cloudy',
        conditionType: WeatherConditionType.partlyCloudy,
        rainProbability: 20,
        windSpeed: 12,
        humidity: 68,
      ),
      HourlyForecast(
        time: '12 PM',
        temperature: 30,
        condition: 'Sunny',
        conditionType: WeatherConditionType.sunny,
        rainProbability: 10,
        windSpeed: 14,
        humidity: 62,
      ),
      HourlyForecast(
        time: '1 PM',
        temperature: 31,
        condition: 'Sunny',
        conditionType: WeatherConditionType.sunny,
        rainProbability: 10,
        windSpeed: 16,
        humidity: 58,
      ),
      HourlyForecast(
        time: '2 PM',
        temperature: 32,
        condition: 'Partly Cloudy',
        conditionType: WeatherConditionType.partlyCloudy,
        rainProbability: 20,
        windSpeed: 16,
        humidity: 56,
      ),
      HourlyForecast(
        time: '3 PM',
        temperature: 32,
        condition: 'Partly Cloudy',
        conditionType: WeatherConditionType.partlyCloudy,
        rainProbability: 30,
        windSpeed: 15,
        humidity: 60,
      ),
      HourlyForecast(
        time: '4 PM',
        temperature: 31,
        condition: 'Chance of Rain',
        conditionType: WeatherConditionType.rainy,
        rainProbability: 45,
        windSpeed: 14,
        humidity: 66,
      ),
      HourlyForecast(
        time: '5 PM',
        temperature: 30,
        condition: 'Rain Shower',
        conditionType: WeatherConditionType.rainy,
        rainProbability: 60,
        windSpeed: 18,
        humidity: 72,
      ),
      HourlyForecast(
        time: '6 PM',
        temperature: 28,
        condition: 'Cloudy',
        conditionType: WeatherConditionType.cloudy,
        rainProbability: 35,
        windSpeed: 12,
        humidity: 75,
      ),
      HourlyForecast(
        time: '7 PM',
        temperature: 27,
        condition: 'Clear',
        conditionType: WeatherConditionType.clearNight,
        rainProbability: 15,
        windSpeed: 10,
        humidity: 78,
      ),
    ];
  }

  @override
  Future<List<DailyForecast>> getDailyForecast(LocationModel location) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return [
      DailyForecast(
        date: now,
        dayName: 'Today',
        tempMax: 34,
        tempMin: 24,
        condition: 'Partly Cloudy',
        conditionType: WeatherConditionType.partlyCloudy,
        rainProbability: 20,
        windSpeed: 12,
        humidity: 68,
        uvIndex: 5,
        summary: 'Warm afternoon with isolated clouds and pleasant evening.',
      ),
      DailyForecast(
        date: now.add(const Duration(days: 1)),
        dayName: 'Tue',
        tempMax: 33,
        tempMin: 25,
        condition: 'Thunderstorm',
        conditionType: WeatherConditionType.thunderstorm,
        rainProbability: 65,
        windSpeed: 20,
        humidity: 76,
        uvIndex: 4,
        summary: 'Afternoon thunderstorms likely with gusty winds.',
      ),
      DailyForecast(
        date: now.add(const Duration(days: 2)),
        dayName: 'Wed',
        tempMax: 31,
        tempMin: 24,
        condition: 'Rain Showers',
        conditionType: WeatherConditionType.rainy,
        rainProbability: 80,
        windSpeed: 18,
        humidity: 82,
        uvIndex: 3,
        summary: 'Passing rain showers throughout the day.',
      ),
      DailyForecast(
        date: now.add(const Duration(days: 3)),
        dayName: 'Thu',
        tempMax: 32,
        tempMin: 23,
        condition: 'Partly Cloudy',
        conditionType: WeatherConditionType.partlyCloudy,
        rainProbability: 30,
        windSpeed: 14,
        humidity: 70,
        uvIndex: 6,
        summary: 'Clearing skies with mild humidity.',
      ),
      DailyForecast(
        date: now.add(const Duration(days: 4)),
        dayName: 'Fri',
        tempMax: 34,
        tempMin: 24,
        condition: 'Sunny',
        conditionType: WeatherConditionType.sunny,
        rainProbability: 10,
        windSpeed: 10,
        humidity: 58,
        uvIndex: 8,
        summary: 'Bright and sunny weather ideal for outdoor plans.',
      ),
      DailyForecast(
        date: now.add(const Duration(days: 5)),
        dayName: 'Sat',
        tempMax: 35,
        tempMin: 25,
        condition: 'Sunny',
        conditionType: WeatherConditionType.sunny,
        rainProbability: 10,
        windSpeed: 12,
        humidity: 55,
        uvIndex: 8,
        summary: 'Warm and dry conditions across the region.',
      ),
      DailyForecast(
        date: now.add(const Duration(days: 6)),
        dayName: 'Sun',
        tempMax: 33,
        tempMin: 24,
        condition: 'Scattered Clouds',
        conditionType: WeatherConditionType.partlyCloudy,
        rainProbability: 25,
        windSpeed: 14,
        humidity: 62,
        uvIndex: 6,
        summary: 'Comfortable day with scattered high clouds.',
      ),
    ];
  }

  @override
  Future<List<DailyForecast>> getExtendedForecast(
      LocationModel location) async {
    final base = await getDailyForecast(location);
    final now = DateTime.now();
    final extended = List<DailyForecast>.from(base);

    for (int i = 7; i <= 14; i++) {
      extended.add(
        DailyForecast(
          date: now.add(Duration(days: i)),
          dayName: 'Day $i',
          tempMax: 32 + (i % 3),
          tempMin: 23 + (i % 2),
          condition: (i % 2 == 0) ? 'Partly Cloudy' : 'Sunny',
          conditionType: (i % 2 == 0)
              ? WeatherConditionType.partlyCloudy
              : WeatherConditionType.sunny,
          rainProbability: (i * 7) % 50,
          windSpeed: 12 + (i % 5).toDouble(),
          humidity: 60 + (i % 15),
          uvIndex: 6,
          summary: 'Typical seasonal outlook for this extended period.',
        ),
      );
    }
    return extended;
  }
}
