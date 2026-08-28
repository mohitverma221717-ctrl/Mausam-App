import { prisma } from '@config/database.js';
import { redis } from '@config/redis.js';
import { logger } from '@config/logger.js';
import { OpenMeteoAQIProvider } from '@integrations/aqi/open-meteo-aqi.provider.js';
import { NormalizedEnvironmentReport, NormalizedAQIData } from '@integrations/aqi/aqi.types.js';
import { LocationService } from '@modules/locations/location.service.js';

export class EnvironmentService {
  private static readonly CACHE_TTL_SEC = 30 * 60; // 30 minutes
  private static provider = new OpenMeteoAQIProvider();

  public static async getEnvironmentReport(lat: number, lon: number): Promise<NormalizedEnvironmentReport> {
    const cacheKey = `env:report:${lat.toFixed(2)}:${lon.toFixed(2)}`;

    try {
      const cached = await redis.get(cacheKey);
      if (cached) {
        return JSON.parse(cached);
      }
    } catch {
      // Ignore cache retrieval failure
    }

    const report = await this.provider.getFullEnvironmentReport(lat, lon);

    try {
      await redis.setex(cacheKey, this.CACHE_TTL_SEC, JSON.stringify(report));
    } catch {
      // Ignore cache write failure
    }

    // Persist to database asynchronously
    void this.persistEnvironmentData(lat, lon, report);

    return report;
  }

  public static async getAQI(lat: number, lon: number): Promise<NormalizedAQIData> {
    const report = await this.getEnvironmentReport(lat, lon);
    return report.aqi;
  }

  private static async persistEnvironmentData(
    lat: number,
    lon: number,
    report: NormalizedEnvironmentReport,
  ) {
    try {
      const location = await LocationService.findOrCreateByCoords(lat, lon);

      await Promise.all([
        prisma.aQIObservation.create({
          data: {
            locationId: location.id,
            observationTime: new Date(report.aqi.observationTime),
            aqi: report.aqi.aqi,
            category: report.aqi.category,
            pm25: report.aqi.pm25,
            pm10: report.aqi.pm10,
            o3: report.aqi.o3,
            no2: report.aqi.no2,
            so2: report.aqi.so2,
            co: report.aqi.co,
            dominantPollutant: report.aqi.dominantPollutant,
            healthAdvisory: report.aqi.healthAdvisory,
            dataSource: report.aqi.dataSource,
            isMock: report.aqi.isMock,
          },
        }),
        prisma.uVObservation.create({
          data: {
            locationId: location.id,
            observationTime: new Date(report.uv.observationTime),
            uvIndex: report.uv.uvIndex,
            maxUvIndex: report.uv.maxUvIndex,
            category: report.uv.category,
            exposureAdvisory: report.uv.exposureAdvisory,
            dataSource: report.uv.dataSource,
          },
        }),
        prisma.pollenObservation.create({
          data: {
            locationId: location.id,
            observationTime: new Date(report.pollen.observationTime),
            grassPollen: report.pollen.grassPollen,
            treePollen: report.pollen.treePollen,
            weedPollen: report.pollen.weedPollen,
            olivePollen: report.pollen.olivePollen,
            overallCategory: report.pollen.overallCategory,
            advisory: report.pollen.advisory,
            dataSource: report.pollen.dataSource,
            isMock: report.pollen.isMock,
          },
        }),
        prisma.visibilityObservation.create({
          data: {
            locationId: location.id,
            observationTime: new Date(report.visibility.observationTime),
            visibilityKm: report.visibility.visibilityKm,
            category: report.visibility.category,
            fogRisk: report.visibility.fogRisk,
            dataSource: report.visibility.dataSource,
          },
        }),
      ]);
    } catch (err) {
      logger.error({ err }, 'Failed to persist environmental observations');
    }
  }
}
