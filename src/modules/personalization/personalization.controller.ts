import { Request, Response, NextFunction } from 'express';
import { PersonalizationService } from './personalization.service.js';
import { sendSuccess } from '@core/utils/response.js';

export class PersonalizationController {
  public static async getHomepage(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userId = req.user?.userId;
      const lat = req.query.latitude ? parseFloat(req.query.latitude as string) : undefined;
      const lon = req.query.longitude ? parseFloat(req.query.longitude as string) : undefined;
      const locationId = req.query.locationId as string | undefined;

      const homepage = await PersonalizationService.getPersonalizedHomepage(userId, lat, lon, locationId);
      sendSuccess(res, homepage);
    } catch (error) {
      next(error);
    }
  }
}
