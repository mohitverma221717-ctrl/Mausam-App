import { PersonaType, RecommendationSeverity } from '@prisma/client';
import { NormalizedWeatherReport } from '@integrations/weather/weather.types.js';
import { NormalizedEnvironmentReport } from '@integrations/aqi/aqi.types.js';

export interface ActionableRecommendation {
  id: string;
  type: string;
  severity: RecommendationSeverity;
  title: string;
  description: string;
  reason: string;
  validFrom: Date;
  validUntil: Date;
  source: string;
  confidence: number;
}

export class RecommendationEngine {
  public static generateRecommendations(
    weather: NormalizedWeatherReport,
    env: NormalizedEnvironmentReport,
    persona: PersonaType = PersonaType.GENERAL,
  ): ActionableRecommendation[] {
    const list: ActionableRecommendation[] = [];
    const now = new Date();
    const endOfDay = new Date(now);
    endOfDay.setHours(23, 59, 59);

    // 1. Rain / Storm Gear Check
    const rainProb = Math.max(
      weather.current.precipitationProb,
      ...weather.hourly.slice(0, 6).map((h) => h.precipitationProb),
    );

    if (rainProb >= 60 || weather.current.condition === 'RAIN' || weather.current.condition === 'HEAVY_RAIN') {
      list.push({
        id: 'rec_rain_umbrella',
        type: 'RAIN_PROTECTION',
        severity: RecommendationSeverity.CAUTION,
        title: 'Carry an Umbrella or Raincoat',
        description: `High likelihood of rainfall (${rainProb}%) detected in your area today.`,
        reason: 'Significant precipitation expected over the next 6 hours.',
        validFrom: now,
        validUntil: endOfDay,
        source: 'IMD_PRECIPITATION_RULE',
        confidence: 0.95,
      });
    }

    // 2. Air Quality & Health Check
    if (env.aqi.aqi > 200) {
      const isSensitive =
        persona === PersonaType.HEALTH_CONSCIOUS || persona === PersonaType.PARENT_FAMILY;
      list.push({
        id: 'rec_aqi_warning',
        type: 'HEALTH_ADVISORY',
        severity: env.aqi.aqi > 300 ? RecommendationSeverity.CRITICAL : RecommendationSeverity.CAUTION,
        title: env.aqi.aqi > 300 ? 'Severe Air Pollution Alert' : 'Unhealthy Air Quality Notice',
        description: isSensitive
          ? 'Wear an N95 mask outdoors and minimize outdoor strenuous activities.'
          : 'Air quality is poor. Sensitive individuals should avoid prolonged exertion outdoors.',
        reason: `AQI index is currently ${env.aqi.aqi} (${env.aqi.category}) with dominant pollutant ${env.aqi.dominantPollutant}.`,
        validFrom: now,
        validUntil: endOfDay,
        source: 'CPCB_AQI_RULE',
        confidence: 0.92,
      });
    }

    // 3. UV & Sun Exposure
    if (env.uv.uvIndex >= 6) {
      list.push({
        id: 'rec_uv_sunscreen',
        type: 'UV_PROTECTION',
        severity: env.uv.uvIndex >= 8 ? RecommendationSeverity.CAUTION : RecommendationSeverity.SUGGESTION,
        title: 'Sunscreen & Shade Advisory',
        description: 'UV radiation is elevated. Apply SPF 30+ sunscreen and wear sunglasses between 11 AM - 3 PM.',
        reason: `Current UV index is ${env.uv.uvIndex.toFixed(1)} (${env.uv.category}).`,
        validFrom: now,
        validUntil: endOfDay,
        source: 'IMD_SOLAR_RADIATION_RULE',
        confidence: 0.9,
      });
    }

    // 4. Fitness / Running Window Check
    if (persona === PersonaType.OUTDOOR_FITNESS) {
      const bestSlot = weather.hourly.slice(0, 12).find((h) => h.temperature <= 28 && h.precipitationProb < 20);
      if (bestSlot) {
        const timeStr = new Date(bestSlot.time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        list.push({
          id: 'rec_fitness_window',
          type: 'FITNESS_OPTIMAL_WINDOW',
          severity: RecommendationSeverity.INFO,
          title: `Best Workout Window at ${timeStr}`,
          description: `Optimal temperature (${bestSlot.temperature}°C) with low rain risk.`,
          reason: 'Ideal meteorological comfort indices for outdoor running or cycling.',
          validFrom: now,
          validUntil: endOfDay,
          source: 'FITNESS_METRIC_ENGINE',
          confidence: 0.88,
        });
      }
    }

    // 5. Agriculture / Farming Advisory
    if (persona === PersonaType.AGRICULTURE_FARMER) {
      if (rainProb < 20 && weather.current.temperature > 32) {
        list.push({
          id: 'rec_agri_irrigation',
          type: 'FARMING_IRRIGATION',
          severity: RecommendationSeverity.SUGGESTION,
          title: 'Optimal Irrigation Window',
          description: 'Dry conditions and high evapotranspiration expected. Schedule field irrigation.',
          reason: 'Minimal precipitation forecasted over the next 48 hours.',
          validFrom: now,
          validUntil: endOfDay,
          source: 'AGRO_METEOROLOGY_RULE',
          confidence: 0.9,
        });
      }
    }

    return list;
  }
}
