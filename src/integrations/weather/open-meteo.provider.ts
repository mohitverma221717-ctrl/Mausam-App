import { WeatherCondition } from '@prisma/client';
import { IWeatherProvider } from './IWeatherProvider.js';
import {
  NormalizedCurrentWeather,
  NormalizedDailyForecast,
  NormalizedHourlyForecast,
  NormalizedWeatherReport,
} from './weather.types.js';
import { logger } from '@config/logger.js';

export class OpenMeteoWeatherProvider implements IWeatherProvider {
  public readonly providerName = 'OPEN_METEO';
  private readonly baseUrl = 'https://api.open-meteo.com/v1/forecast';

  public async getCurrentWeather(lat: number, lon: number): Promise<NormalizedCurrentWeather> {
    const report = await this.getFullWeatherForecast(lat, lon);
    return report.current;
  }

  public async getFullWeatherForecast(lat: number, lon: number): Promise<NormalizedWeatherReport> {
    const url = `${this.baseUrl}?latitude=${lat}&longitude=${lon}&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,cloud_cover,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,precipitation,weather_code,wind_speed_10m,wind_direction_10m,uv_index&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,precipitation_probability_max,wind_speed_10m_max,uv_index_max&timezone=auto`;

    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`Open-Meteo API returned status ${response.status}`);
      }
      const data = await response.json();
      return this.mapResponse(data);
    } catch (error) {
      logger.error({ error, lat, lon }, 'Failed to fetch Open-Meteo weather data');
      throw error;
    }
  }

  private mapResponse(data: any): NormalizedWeatherReport {
    const current = data.current;
    const hourly = data.hourly;
    const daily = data.daily;

    const condition = this.mapWmoCode(current.weather_code);

    const normalizedCurrent: NormalizedCurrentWeather = {
      temperature: current.temperature_2m,
      feelsLike: current.apparent_temperature,
      humidity: current.relative_humidity_2m,
      pressure: current.surface_pressure,
      windSpeed: current.wind_speed_10m,
      windDirection: current.wind_direction_10m,
      windGust: current.wind_gusts_10m,
      precipitation: current.precipitation,
      precipitationProb: 0,
      cloudCover: current.cloud_cover,
      uvIndex: hourly?.uv_index?.[0] || 0,
      visibility: 10.0,
      condition,
      conditionCode: current.weather_code,
      iconCode: this.getIconForCondition(condition),
      observationTime: new Date(current.time),
      dataSource: this.providerName,
      isMock: false,
    };

    const normalizedHourly: NormalizedHourlyForecast[] = [];
    if (hourly?.time) {
      const count = Math.min(24, hourly.time.length);
      for (let i = 0; i < count; i++) {
        const cond = this.mapWmoCode(hourly.weather_code[i]);
        normalizedHourly.push({
          time: new Date(hourly.time[i]),
          temperature: hourly.temperature_2m[i],
          feelsLike: hourly.apparent_temperature[i],
          humidity: hourly.relative_humidity_2m[i],
          precipitationProb: hourly.precipitation_probability[i] || 0,
          precipitation: hourly.precipitation[i] || 0,
          windSpeed: hourly.wind_speed_10m[i],
          windDirection: hourly.wind_direction_10m[i],
          condition: cond,
          iconCode: this.getIconForCondition(cond),
          uvIndex: hourly.uv_index[i] || 0,
        });
      }
    }

    const normalizedDaily: NormalizedDailyForecast[] = [];
    if (daily?.time) {
      const count = Math.min(7, daily.time.length);
      for (let i = 0; i < count; i++) {
        const cond = this.mapWmoCode(daily.weather_code[i]);
        normalizedDaily.push({
          date: new Date(daily.time[i]),
          minTemp: daily.temperature_2m_min[i],
          maxTemp: daily.temperature_2m_max[i],
          condition: cond,
          precipitationProb: daily.precipitation_probability_max[i] || 0,
          precipitationSum: daily.precipitation_sum[i] || 0,
          sunrise: daily.sunrise?.[i] ? new Date(daily.sunrise[i]) : undefined,
          sunset: daily.sunset?.[i] ? new Date(daily.sunset[i]) : undefined,
          uvMax: daily.uv_index_max?.[i] || 0,
          windMax: daily.wind_speed_10m_max?.[i] || 0,
        });
      }
    }

    return {
      current: normalizedCurrent,
      hourly: normalizedHourly,
      daily: normalizedDaily,
    };
  }

  private mapWmoCode(wmoCode: number): WeatherCondition {
    if (wmoCode === 0) return WeatherCondition.CLEAR;
    if (wmoCode === 1 || wmoCode === 2) return WeatherCondition.PARTLY_CLOUDY;
    if (wmoCode === 3) return WeatherCondition.CLOUDY;
    if (wmoCode === 45 || wmoCode === 48) return WeatherCondition.FOG;
    if (wmoCode >= 51 && wmoCode <= 55) return WeatherCondition.DRIZZLE;
    if (wmoCode >= 61 && wmoCode <= 65) return WeatherCondition.RAIN;
    if (wmoCode >= 66 && wmoCode <= 67) return WeatherCondition.HEAVY_RAIN;
    if (wmoCode >= 71 && wmoCode <= 77) return WeatherCondition.SNOW;
    if (wmoCode >= 80 && wmoCode <= 82) return WeatherCondition.HEAVY_RAIN;
    if (wmoCode >= 95 && wmoCode <= 99) return WeatherCondition.THUNDERSTORM;
    return WeatherCondition.CLEAR;
  }

  private getIconForCondition(condition: WeatherCondition): string {
    switch (condition) {
      case WeatherCondition.CLEAR:
        return '01d';
      case WeatherCondition.PARTLY_CLOUDY:
        return '02d';
      case WeatherCondition.CLOUDY:
      case WeatherCondition.OVERCAST:
        return '03d';
      case WeatherCondition.FOG:
        return '50d';
      case WeatherCondition.DRIZZLE:
        return '09d';
      case WeatherCondition.RAIN:
      case WeatherCondition.HEAVY_RAIN:
        return '10d';
      case WeatherCondition.THUNDERSTORM:
        return '11d';
      case WeatherCondition.SNOW:
      case WeatherCondition.HAIL:
        return '13d';
      default:
        return '01d';
    }
  }
}
