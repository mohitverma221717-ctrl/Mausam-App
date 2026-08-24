import { Request, Response, NextFunction } from 'express';
import { EnvironmentService } from './environment.service.js';
import { LocationService } from '@modules/locations/location.service.js';
import { sendSuccess } from '@core/utils/response.js';

export class EnvironmentController {
  public static async getFullReport(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await EnvironmentController.extractCoordinates(req);
      const data = await EnvironmentService.getEnvironmentReport(lat, lon);
      sendSuccess(res, data);
    } catch (error) {
      next(error);
    }
  }

  public static async getAQI(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await EnvironmentController.extractCoordinates(req);
      const data = await EnvironmentService.getAQI(lat, lon);
      sendSuccess(res, data);
    } catch (error) {
      next(error);
    }
  }

  public static async getUV(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await EnvironmentController.extractCoordinates(req);
      const data = await EnvironmentService.getEnvironmentReport(lat, lon);
      sendSuccess(res, data.uv);
    } catch (error) {
      next(error);
    }
  }

  public static async getPollen(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await EnvironmentController.extractCoordinates(req);
      const data = await EnvironmentService.getEnvironmentReport(lat, lon);
      sendSuccess(res, data.pollen);
    } catch (error) {
      next(error);
    }
  }

  public static async getVisibility(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await EnvironmentController.extractCoordinates(req);
      const data = await EnvironmentService.getEnvironmentReport(lat, lon);
      sendSuccess(res, data.visibility);
    } catch (error) {
      next(error);
    }
  }

  private static async extractCoordinates(req: Request): Promise<{ lat: number; lon: number }> {
    if (req.query.latitude && req.query.longitude) {
      const lat = parseFloat(req.query.latitude as string);
      const lon = parseFloat(req.query.longitude as string);
      if (!isNaN(lat) && !isNaN(lon)) {
        return { lat, lon };
      }
    }

    if (req.query.locationId) {
      const loc = await LocationService.getLocationById(req.query.locationId as string);
      return { lat: loc.latitude, lon: loc.longitude };
    }

    return { lat: 28.5847, lon: 77.2066 };
  }
}
