import { Request, Response, NextFunction } from 'express';
import { AlertService } from './alert.service.js';
import { sendSuccess, sendCreated } from '@core/utils/response.js';

export class AlertController {
  public static async getActive(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const lat = req.query.latitude ? parseFloat(req.query.latitude as string) : undefined;
      const lon = req.query.longitude ? parseFloat(req.query.longitude as string) : undefined;

      const alerts = await AlertService.getActiveAlerts(lat, lon);
      sendSuccess(res, alerts);
    } catch (error) {
      next(error);
    }
  }

  public static async getById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const alert = await AlertService.getAlertById(req.params.id);
      sendSuccess(res, alert);
    } catch (error) {
      next(error);
    }
  }

  public static async create(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AlertService.createAlert(req.body);
      sendCreated(res, result);
    } catch (error) {
      next(error);
    }
  }
}
