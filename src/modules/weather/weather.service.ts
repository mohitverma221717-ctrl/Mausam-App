import { prisma } from '@config/database.js';
import { redis } from '@config/redis.js';
import { logger } from '@config/logger.js';
import { WeatherProviderFactory } from '@integrations/weather/weather-provider.factory.js';
import { NormalizedWeatherReport, NormalizedCurrentWeather } from '@integrations/weather/weather.types.js';
import { LocationService } from '@modules/locations/location.service.js';

export class WeatherService {
  private static readonly CACHE_TTL_CURRENT_SEC = 15 * 60; // 15 mins
  private static readonly CACHE_TTL_FORECAST_SEC = 60 * 60; // 1 hour

  public static async getCurrentWeather(lat: number, lon: number): Promise<NormalizedCurrentWeather> {
    const cacheKey = `weather:current:${lat.toFixed(2)}:${lon.toFixed(2)}`;

    try {
      const cached = await redis.get(cacheKey);
      if (cached) {
        return JSON.parse(cached);
      }
    } catch {
      // Ignore cache retrieval failure
    }

    const provider = WeatherProviderFactory.getProvider();
    let current: NormalizedCurrentWeather;

    try {
      current = await provider.getCurrentWeather(lat, lon);
    } catch (err) {
      logger.warn({ err }, 'Primary weather provider failed, falling back to mock provider');
      current = await WeatherProviderFactory.getFallbackProvider().getCurrentWeather(lat, lon);
    }

    // Cache in Redis
    try {
      await redis.setex(cacheKey, this.CACHE_TTL_CURRENT_SEC, JSON.stringify(current));
    } catch {
      // Ignore cache write failure
    }

    // Persist observation to DB asynchronously
    void this.persistCurrentObservation(lat, lon, current);

    return current;
  }

  public static async getFullForecast(lat: number, lon: number): Promise<NormalizedWeatherReport> {
    const cacheKey = `weather:forecast:${lat.toFixed(2)}:${lon.toFixed(2)}`;

    try {
      const cached = await redis.get(cacheKey);
      if (cached) {
        return JSON.parse(cached);
      }
    } catch {
      // Ignore cache failure
    }

    const provider = WeatherProviderFactory.getProvider();
    let report: NormalizedWeatherReport;

    try {
      report = await provider.getFullWeatherForecast(lat, lon);
    } catch (err) {
      logger.warn({ err }, 'Primary forecast provider failed, using fallback');
      report = await WeatherProviderFactory.getFallbackProvider().getFullWeatherForecast(lat, lon);
    }

    try {
      await redis.setex(cacheKey, this.CACHE_TTL_FORECAST_SEC, JSON.stringify(report));
    } catch {
      // Ignore cache write failure
    }

    // Persist forecast to DB asynchronously
    void this.persistForecastData(lat, lon, report);

    return report;
  }

  private static async persistCurrentObservation(
    lat: number,
    lon: number,
    weather: NormalizedCurrentWeather,
  ) {
    try {
      const location = await LocationService.findOrCreateByCoords(lat, lon);
      await prisma.weatherObservation.create({
        data: {
          locationId: location.id,
          observationTime: new Date(weather.observationTime),
          temperature: weather.temperature,
          feelsLike: weather.feelsLike,
          minTemp: weather.minTemp,
          maxTemp: weather.maxTemp,
          humidity: weather.humidity,
          pressure: weather.pressure,
          windSpeed: weather.windSpeed,
          windDirection: weather.windDirection,
          windGust: weather.windGust,
          precipitation: weather.precipitation,
          precipitationProb: weather.precipitationProb,
          cloudCover: weather.cloudCover,
          uvIndex: weather.uvIndex,
          visibility: weather.visibility,
          condition: weather.condition,
          conditionCode: weather.conditionCode,
          iconCode: weather.iconCode,
          dataSource: weather.dataSource,
          isMock: weather.isMock,
        },
      });
    } catch (err) {
      logger.error({ err }, 'Failed to persist weather observation to database');
    }
  }

  private static async persistForecastData(lat: number, lon: number, report: NormalizedWeatherReport) {
    try {
      const location = await LocationService.findOrCreateByCoords(lat, lon);
      const forecastDate = new Date();
      forecastDate.setHours(0, 0, 0, 0);

      const forecastRecord = await prisma.weatherForecast.upsert({
        where: {
          locationId_forecastDate: {
            locationId: location.id,
            forecastDate,
          },
        },
        update: {
          dataSource: report.current.dataSource,
        },
        create: {
          locationId: location.id,
          forecastDate,
          dataSource: report.current.dataSource,
        },
      });

      // Clear older hourly forecasts for today and insert new
      await prisma.hourlyForecast.deleteMany({ where: { forecastId: forecastRecord.id } });
      await prisma.dailyForecast.deleteMany({ where: { forecastId: forecastRecord.id } });

      if (report.hourly.length > 0) {
        await prisma.hourlyForecast.createMany({
          data: report.hourly.map((h) => ({
            forecastId: forecastRecord.id,
            time: new Date(h.time),
            temperature: h.temperature,
            feelsLike: h.feelsLike,
            humidity: h.humidity,
            precipitationProb: h.precipitationProb,
            precipitation: h.precipitation,
            windSpeed: h.windSpeed,
            windDirection: h.windDirection,
            condition: h.condition,
            iconCode: h.iconCode,
            uvIndex: h.uvIndex,
          })),
        });
      }

      if (report.daily.length > 0) {
        await prisma.dailyForecast.createMany({
          data: report.daily.map((d) => ({
            forecastId: forecastRecord.id,
            date: new Date(d.date),
            minTemp: d.minTemp,
            maxTemp: d.maxTemp,
            condition: d.condition,
            precipitationProb: d.precipitationProb,
            precipitationSum: d.precipitationSum,
            sunrise: d.sunrise ? new Date(d.sunrise) : undefined,
            sunset: d.sunset ? new Date(d.sunset) : undefined,
            uvMax: d.uvMax,
            windMax: d.windMax,
          })),
        });
      }
    } catch (err) {
      logger.error({ err }, 'Failed to persist full forecast to database');
    }
  }
}
