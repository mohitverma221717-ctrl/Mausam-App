import { prisma } from '@config/database.js';
import { WeatherService } from '@modules/weather/weather.service.js';
import { EnvironmentService } from '@modules/environment/environment.service.js';

export class DomainsService {
  // 1. Agriculture / Farm Module
  public static async getFarms(userId: string) {
    return prisma.farm.findMany({
      where: { userId },
      include: {
        location: true,
        soilObservations: { take: 5, orderBy: { observationTime: 'desc' } },
        farmingAdvisories: { take: 5, orderBy: { createdAt: 'desc' } },
      },
    });
  }

  public static async createFarm(
    userId: string,
    data: {
      farmName: string;
      cropType: string;
      soilType: string;
      locationId: string;
      areaInAcres?: number;
    },
  ) {
    return prisma.farm.create({
      data: {
        userId,
        ...data,
      },
      include: { location: true },
    });
  }

  // 2. Marine / Coastal Module
  public static async getMarineConditions(lat: number, lon: number) {
    const weather = await WeatherService.getCurrentWeather(lat, lon);
    // Calculated marine parameters based on wind speed and pressure
    const waveHeight = Math.max(0.5, Math.round((weather.windSpeed * 0.08) * 10) / 10);
    const isSafe = waveHeight < 2.5 && weather.windSpeed < 35;

    return {
      waveHeightM: waveHeight,
      wavePeriodSec: 7.5,
      waveDirection: weather.windDirection,
      seaTempCelsius: Math.round((weather.temperature - 1.5) * 10) / 10,
      tideType: 'NORMAL',
      tideHeightM: 1.2,
      seaCondition: waveHeight < 1.0 ? 'CALM' : waveHeight < 2.0 ? 'MODERATE' : 'ROUGH',
      swimmingSafety: isSafe,
      advisory: isSafe
        ? 'Sea conditions are normal. Safe for coastal activities and small craft.'
        : 'Rough seas and strong currents forecasted. Fishermen and swimmers advised not to venture into deep sea.',
    };
  }

  // 3. Fitness Module
  public static async getFitnessScore(lat: number, lon: number) {
    const [weather, env] = await Promise.all([
      WeatherService.getCurrentWeather(lat, lon),
      EnvironmentService.getAQI(lat, lon),
    ]);

    let score = 100;
    if (weather.temperature > 32) score -= 20;
    if (weather.temperature < 10) score -= 15;
    if (weather.humidity > 75) score -= 15;
    if (env.aqi > 150) score -= 30;
    if (weather.precipitation > 0) score -= 35;

    score = Math.max(10, Math.min(100, score));

    return {
      outdoorScore: score,
      temperature: weather.temperature,
      aqi: env.aqi,
      humidity: weather.humidity,
      summary:
        score >= 80
          ? 'Excellent conditions for running and outdoor workouts.'
          : score >= 50
            ? 'Moderate conditions. Stay hydrated and avoid intense midday cardio.'
            : 'Poor outdoor conditions. Indoor workout strongly recommended.',
    };
  }

  // 4. Travel Module
  public static async getTrips(userId: string) {
    return prisma.trip.findMany({
      where: { userId },
      include: {
        destinations: {
          include: {
            location: true,
            packingRecommendations: true,
          },
        },
      },
    });
  }

  // 5. Family Module
  public static async getFamilyProfile(userId: string) {
    return prisma.familyProfile.findUnique({
      where: { userId },
      include: {
        schoolLocations: {
          include: {
            location: true,
            advisories: { take: 3, orderBy: { date: 'desc' } },
          },
        },
      },
    });
  }

  // 6. Commute Module
  public static async getCommuteRoutes(userId: string) {
    return prisma.commuteRoute.findMany({
      where: { userId },
    });
  }

  // 7. Outdoor Events Module
  public static async getOutdoorEvents(userId: string) {
    return prisma.outdoorEvent.findMany({
      where: { userId },
      orderBy: { eventDate: 'asc' },
    });
  }
}
