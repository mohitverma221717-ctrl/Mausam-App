import { Request, Response, NextFunction } from 'express';
import { prisma } from '@config/database.js';
import { WeatherService } from '@modules/weather/weather.service.js';
import { EnvironmentService } from '@modules/environment/environment.service.js';
import { RecommendationEngine } from './recommendation.service.js';
import { sendSuccess } from '@core/utils/response.js';
import { PersonaType } from '@prisma/client';

export class RecommendationController {
  public static async getRecommendations(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const lat = req.query.latitude ? parseFloat(req.query.latitude as string) : 28.5847;
      const lon = req.query.longitude ? parseFloat(req.query.longitude as string) : 77.2066;

      let persona: PersonaType = PersonaType.GENERAL;
      if (req.user) {
        const profile = await prisma.userProfile.findUnique({
          where: { userId: req.user.userId },
        });
        if (profile) persona = profile.persona;
      }

      const [weather, env] = await Promise.all([
        WeatherService.getFullForecast(lat, lon),
        EnvironmentService.getEnvironmentReport(lat, lon),
      ]);

      const recommendations = RecommendationEngine.generateRecommendations(weather, env, persona);
      sendSuccess(res, recommendations);
    } catch (error) {
      next(error);
    }
  }

  public static async recordInteraction(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { recommendationId, action } = req.body;
      const userId = req.user!.userId;

      // Asynchronously log interaction for analytics
      void prisma.recommendationHistory.create({
        data: {
          userId,
          recommendationId: recommendationId || 'rec_general',
          action: action || 'CLICKED',
        },
      });

      sendSuccess(res, { message: 'Interaction recorded' });
    } catch (error) {
      next(error);
    }
  }
}
