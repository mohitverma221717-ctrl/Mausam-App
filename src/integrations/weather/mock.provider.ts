import { WeatherCondition } from '@prisma/client';
import { IWeatherProvider } from './IWeatherProvider.js';
import {
  NormalizedCurrentWeather,
  NormalizedDailyForecast,
  NormalizedHourlyForecast,
  NormalizedWeatherReport,
} from './weather.types.js';
import { addHours, addDays } from '@core/utils/date-time.js';

export class MockWeatherProvider implements IWeatherProvider {
  public readonly providerName = 'IMD_MOCK';

  public async getCurrentWeather(_lat: number, _lon: number): Promise<NormalizedCurrentWeather> {
    return {
      temperature: 29.5,
      feelsLike: 31.0,
      minTemp: 22.0,
      maxTemp: 34.0,
      humidity: 62.0,
      pressure: 1012.0,
      windSpeed: 12.5,
      windDirection: 180,
      windGust: 18.0,
      precipitation: 0.0,
      precipitationProb: 15,
      cloudCover: 25.0,
      uvIndex: 6.5,
      visibility: 8.5,
      condition: WeatherCondition.PARTLY_CLOUDY,
      conditionCode: 801,
      iconCode: '02d',
      observationTime: new Date(),
      dataSource: this.providerName,
      isMock: true,
    };
  }

  public async getFullWeatherForecast(lat: number, lon: number): Promise<NormalizedWeatherReport> {
    const current = await this.getCurrentWeather(lat, lon);
    const hourly: NormalizedHourlyForecast[] = [];
    const now = new Date();

    for (let i = 1; i <= 24; i++) {
      hourly.push({
        time: addHours(now, i),
        temperature: Math.round((28 + Math.sin(i / 3) * 6) * 10) / 10,
        feelsLike: Math.round((29 + Math.sin(i / 3) * 6) * 10) / 10,
        humidity: Math.round(50 + Math.cos(i / 4) * 20),
        precipitationProb: i % 6 === 0 ? 40 : 10,
        precipitation: i % 6 === 0 ? 2.5 : 0.0,
        windSpeed: 10.0 + (i % 5),
        windDirection: 180,
        condition: i % 6 === 0 ? WeatherCondition.RAIN : WeatherCondition.PARTLY_CLOUDY,
        iconCode: i % 6 === 0 ? '10d' : '02d',
        uvIndex: i >= 6 && i <= 18 ? 6 : 0,
      });
    }

    const daily: NormalizedDailyForecast[] = [];
    for (let i = 0; i < 7; i++) {
      const d = addDays(now, i);
      daily.push({
        date: d,
        minTemp: 22.0 + (i % 3),
        maxTemp: 34.0 + (i % 2),
        condition: i === 2 ? WeatherCondition.THUNDERSTORM : WeatherCondition.CLEAR,
        precipitationProb: i === 2 ? 75 : 10,
        precipitationSum: i === 2 ? 15.0 : 0.0,
        sunrise: new Date(d.setHours(5, 45, 0)),
        sunset: new Date(d.setHours(18, 35, 0)),
        uvMax: 8.0,
        windMax: 20.0,
      });
    }

    return {
      current,
      hourly,
      daily,
    };
  }
}
