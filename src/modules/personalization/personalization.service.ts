import { CardType, PersonaType } from '@prisma/client';
import { prisma } from '@config/database.js';
import { WeatherService } from '@modules/weather/weather.service.js';
import { EnvironmentService } from '@modules/environment/environment.service.js';
import { ContextAnalyzer } from './ContextAnalyzer.js';
import { PriorityEngine } from './PriorityEngine.js';
import { RecommendationEngine } from '@modules/recommendations/recommendation.service.js';
import { LocationService } from '@modules/locations/location.service.js';
import {
  HomepageCardItem,
  PersonalizedHomepageResponse,
} from './personalization.types.js';

export class PersonalizationService {
  public static async getPersonalizedHomepage(
    userId?: string,
    lat?: number,
    lon?: number,
    locationId?: string,
  ): Promise<PersonalizedHomepageResponse> {
    // 1. Resolve Location
    let locationTarget: {
      id: string;
      name: string;
      state?: string | null;
      country: string;
      latitude: number;
      longitude: number;
    } = {
      id: 'default',
      name: 'New Delhi (Safdarjung)',
      state: 'Delhi',
      country: 'India',
      latitude: 28.5847,
      longitude: 77.2066,
    };

    if (locationId) {
      const loc = await LocationService.getLocationById(locationId);
      locationTarget = loc;
    } else if (lat !== undefined && lon !== undefined) {
      const loc = await LocationService.findOrCreateByCoords(lat, lon);
      locationTarget = loc;
    } else if (userId) {
      const saved = await LocationService.getSavedLocations(userId);
      if (saved.length > 0 && saved[0]) {
        locationTarget = saved[0].location;
      }
    }

    // 2. Fetch User Profile & Preferences
    let persona: PersonaType = PersonaType.GENERAL;
    let tempUnit = 'C';
    const hiddenCards = new Set<CardType>();

    if (userId) {
      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: {
          profile: true,
          preferences: true,
          cardPreferences: true,
        },
      });

      if (user) {
        if (user.profile?.persona) persona = user.profile.persona;
        if (user.preferences?.tempUnit) tempUnit = user.preferences.tempUnit;
        if (user.cardPreferences) {
          user.cardPreferences
            .filter((cp) => cp.isHidden)
            .forEach((cp) => hiddenCards.add(cp.cardType));
        }
      }
    }

    // 3. Parallel Fetch: Weather, Environment & Active Alerts (with resilient DB fallback)
    const [weatherReport, envReport, activeAlerts] = await Promise.all([
      WeatherService.getFullForecast(locationTarget.latitude, locationTarget.longitude),
      EnvironmentService.getEnvironmentReport(locationTarget.latitude, locationTarget.longitude),
      prisma.alert
        .findMany({
          where: {
            isApproved: true,
            expiresAt: { gte: new Date() },
          },
          take: 5,
        })
        .catch(() => []),
    ]);

    // 4. Context Analysis
    const context = ContextAnalyzer.analyze(weatherReport, envReport);

    // 5. Generate Recommendations
    const recommendations = RecommendationEngine.generateRecommendations(
      weatherReport,
      envReport,
      persona,
    );

    // 6. Assemble & Hydrate Cards
    const rawCards: HomepageCardItem[] = [
      // 1. Current Weather
      {
        id: 'card_current_weather',
        type: CardType.CURRENT_WEATHER,
        priority: PriorityEngine.calculatePriority(CardType.CURRENT_WEATHER, persona, context),
        title: 'Current Conditions',
        subtitle: `${weatherReport.current.condition.replace('_', ' ')} • Feels like ${weatherReport.current.feelsLike}°${tempUnit}`,
        data: {
          temperature: weatherReport.current.temperature,
          feelsLike: weatherReport.current.feelsLike,
          humidity: weatherReport.current.humidity,
          windSpeed: weatherReport.current.windSpeed,
          condition: weatherReport.current.condition,
          iconCode: weatherReport.current.iconCode,
          visibility: weatherReport.current.visibility,
          uvIndex: weatherReport.current.uvIndex,
        },
      },
      // 2. Hourly Forecast
      {
        id: 'card_hourly_forecast',
        type: CardType.HOURLY_FORECAST,
        priority: PriorityEngine.calculatePriority(CardType.HOURLY_FORECAST, persona, context),
        title: 'Hourly Forecast',
        subtitle: 'Next 24 Hours',
        data: {
          hourly: weatherReport.hourly.slice(0, 12),
        },
      },
      // 3. Daily Forecast
      {
        id: 'card_daily_forecast',
        type: CardType.DAILY_FORECAST,
        priority: PriorityEngine.calculatePriority(CardType.DAILY_FORECAST, persona, context),
        title: '7-Day Outlook',
        subtitle: 'Upcoming Week',
        data: {
          daily: weatherReport.daily,
        },
      },
      // 4. Air Quality Index
      {
        id: 'card_air_quality',
        type: CardType.AIR_QUALITY,
        priority: PriorityEngine.calculatePriority(CardType.AIR_QUALITY, persona, context),
        title: 'Air Quality (AQI)',
        subtitle: `${envReport.aqi.category} • ${envReport.aqi.aqi} AQI`,
        badge:
          envReport.aqi.aqi > 200
            ? { text: envReport.aqi.category, type: 'critical' }
            : { text: envReport.aqi.category, type: 'info' },
        data: {
          aqi: envReport.aqi.aqi,
          category: envReport.aqi.category,
          pm25: envReport.aqi.pm25,
          pm10: envReport.aqi.pm10,
          dominantPollutant: envReport.aqi.dominantPollutant,
          healthAdvisory: envReport.aqi.healthAdvisory,
        },
      },
      // 5. UV & Solar Radiation
      {
        id: 'card_uv_index',
        type: CardType.UV_INDEX,
        priority: PriorityEngine.calculatePriority(CardType.UV_INDEX, persona, context),
        title: 'UV Index',
        subtitle: `${envReport.uv.category} (${envReport.uv.uvIndex.toFixed(1)})`,
        data: {
          uvIndex: envReport.uv.uvIndex,
          category: envReport.uv.category,
          exposureAdvisory: envReport.uv.exposureAdvisory,
        },
      },
      // 6. Pollen Report
      {
        id: 'card_pollen_report',
        type: CardType.POLLEN_REPORT,
        priority: PriorityEngine.calculatePriority(CardType.POLLEN_REPORT, persona, context),
        title: 'Pollen Levels',
        subtitle: `Overall: ${envReport.pollen.overallCategory}`,
        data: {
          overallCategory: envReport.pollen.overallCategory,
          grassPollen: envReport.pollen.grassPollen,
          treePollen: envReport.pollen.treePollen,
          advisory: envReport.pollen.advisory,
        },
      },
      // 7. Recommendations Card
      {
        id: 'card_recommendations',
        type: CardType.RECOMMENDATIONS,
        priority: PriorityEngine.calculatePriority(CardType.RECOMMENDATIONS, persona, context),
        title: 'Daily Recommendations',
        subtitle: `${recommendations.length} actionable insights`,
        data: {
          items: recommendations,
        },
      },
    ];

    // Add Severe Alerts Card if active alerts exist
    if (activeAlerts.length > 0) {
      rawCards.unshift({
        id: 'card_severe_alerts',
        type: CardType.SEVERE_ALERTS,
        priority: 150, // Always top priority when active
        title: 'Active Meteorological Warnings',
        subtitle: `${activeAlerts.length} Warning(s) Active`,
        badge: { text: 'WARNING', type: 'critical' },
        data: {
          alerts: activeAlerts,
        },
      });
    }

    // Filter out user-hidden cards & sort by dynamic priority descending
    const filteredCards = rawCards
      .filter((card) => !hiddenCards.has(card.type))
      .sort((a, b) => b.priority - a.priority);

    return {
      location: locationTarget,
      persona,
      weatherSummary: {
        temperature: weatherReport.current.temperature,
        feelsLike: weatherReport.current.feelsLike,
        condition: weatherReport.current.condition,
        iconCode: weatherReport.current.iconCode,
        tempUnit,
      },
      environmentalSummary: {
        aqi: envReport.aqi.aqi,
        aqiCategory: envReport.aqi.category,
        uvIndex: envReport.uv.uvIndex,
        uvCategory: envReport.uv.category,
      },
      activeAlertsCount: activeAlerts.length,
      cards: filteredCards,
      recommendations: recommendations.map((r) => ({
        id: r.id,
        type: r.type,
        severity: r.severity,
        title: r.title,
        description: r.description,
        reason: r.reason,
      })),
    };
  }
}
