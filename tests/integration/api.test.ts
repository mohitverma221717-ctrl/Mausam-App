import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { createApp } from '../../src/app.js';
import { PriorityEngine } from '../../src/modules/personalization/PriorityEngine.js';
import { RecommendationEngine } from '../../src/modules/recommendations/recommendation.service.js';
import { MockWeatherProvider } from '../../src/integrations/weather/mock.provider.js';
import { OpenMeteoAQIProvider } from '../../src/integrations/aqi/open-meteo-aqi.provider.js';
import { CardType, PersonaType } from '@prisma/client';

describe('Mausam Full REST API & Engine Integration Suite', () => {
  const app = createApp();

  describe('1. Personalization Engine (Core USP)', () => {
    it('ranks Air Quality and Pollen highest for HEALTH_CONSCIOUS persona', () => {
      const aqiScore = PriorityEngine.calculatePriority(
        CardType.AIR_QUALITY,
        PersonaType.HEALTH_CONSCIOUS,
        {
          isSevereAqi: false,
          isHighUv: false,
          isRainImminent: false,
          isExtremeTemperature: false,
          isHighPollen: false,
          isFoggy: false,
        },
      );

      const runningScore = PriorityEngine.calculatePriority(
        CardType.FITNESS_RUNNING_WINDOW,
        PersonaType.HEALTH_CONSCIOUS,
        {
          isSevereAqi: false,
          isHighUv: false,
          isRainImminent: false,
          isExtremeTemperature: false,
          isHighPollen: false,
          isFoggy: false,
        },
      );

      expect(aqiScore).toBeGreaterThan(runningScore);
    });

    it('boosts Air Quality and Health Advisory cards dramatically when AQI is severe (>200)', () => {
      const normalScore = PriorityEngine.calculatePriority(
        CardType.AIR_QUALITY,
        PersonaType.GENERAL,
        {
          isSevereAqi: false,
          isHighUv: false,
          isRainImminent: false,
          isExtremeTemperature: false,
          isHighPollen: false,
          isFoggy: false,
        },
      );

      const severeScore = PriorityEngine.calculatePriority(
        CardType.AIR_QUALITY,
        PersonaType.GENERAL,
        {
          isSevereAqi: true,
          isHighUv: false,
          isRainImminent: false,
          isExtremeTemperature: false,
          isHighPollen: false,
          isFoggy: false,
        },
      );

      expect(severeScore).toBe(normalScore + 40);
    });

    it('GET /api/v1/home returns complete personalized structure with ranked cards', async () => {
      const res = await request(app).get('/api/v1/home');
      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.location).toBeDefined();
      expect(res.body.data.weatherSummary).toBeDefined();
      expect(res.body.data.environmentalSummary).toBeDefined();
      expect(Array.isArray(res.body.data.cards)).toBe(true);
      expect(res.body.data.cards.length).toBeGreaterThan(0);
      // Ensure sorted descending by priority
      const priorities = res.body.data.cards.map((c: any) => c.priority);
      for (let i = 0; i < priorities.length - 1; i++) {
        expect(priorities[i]).toBeGreaterThanOrEqual(priorities[i + 1]);
      }
    });
  });

  describe('2. Recommendation Engine', () => {
    it('generates umbrella recommendation when rain is forecasted', async () => {
      const mockWeather = await new MockWeatherProvider().getFullWeatherForecast(28.58, 77.2);
      mockWeather.current.precipitationProb = 80;
      mockWeather.current.condition = 'RAIN';

      const mockEnv = await new OpenMeteoAQIProvider().getFullEnvironmentReport(28.58, 77.2);

      const recommendations = RecommendationEngine.generateRecommendations(
        mockWeather,
        mockEnv,
        PersonaType.GENERAL,
      );

      const umbrellaRec = recommendations.find((r) => r.type === 'RAIN_PROTECTION');
      expect(umbrellaRec).toBeDefined();
      expect(umbrellaRec?.title).toContain('Umbrella');
    });

    it('GET /api/v1/recommendations returns actionable advice list', async () => {
      const res = await request(app).get('/api/v1/recommendations');
      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(Array.isArray(res.body.data)).toBe(true);
    });
  });

  describe('3. Weather & Environment REST Endpoints', () => {
    it('GET /api/v1/weather/current returns current weather data', async () => {
      const res = await request(app).get('/api/v1/weather/current');
      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.temperature).toBeDefined();
      expect(res.body.data.humidity).toBeDefined();
      expect(res.body.data.condition).toBeDefined();
    });

    it('GET /api/v1/environment/aqi returns AQI and pollutant breakdown', async () => {
      const res = await request(app).get('/api/v1/environment/aqi');
      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.aqi).toBeDefined();
      expect(res.body.data.category).toBeDefined();
      expect(res.body.data.healthAdvisory).toBeDefined();
    });
  });

  describe('4. RBAC & Security Access Control', () => {
    it('rejects unauthenticated requests to protected admin endpoints with 401', async () => {
      const res = await request(app).get('/api/v1/admin/dashboard');
      expect(res.status).toBe(401);
      expect(res.body.success).toBe(false);
      expect(res.body.error.code).toBe('UNAUTHORIZED');
    });

    it('rejects unauthenticated requests to user profile with 401', async () => {
      const res = await request(app).get('/api/v1/users/profile');
      expect(res.status).toBe(401);
      expect(res.body.success).toBe(false);
      expect(res.body.error.code).toBe('UNAUTHORIZED');
    });
  });

  describe('5. Location Services', () => {
    it('GET /api/v1/locations/search?query=delhi returns search matches', async () => {
      const res = await request(app).get('/api/v1/locations/search?query=delhi');
      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(Array.isArray(res.body.data)).toBe(true);
    });
  });
});
