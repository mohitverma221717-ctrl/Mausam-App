import { Request, Response, NextFunction } from 'express';
import { AnalyticsService } from './analytics.service.js';
import { sendSuccess, sendCreated } from '@core/utils/response.js';

export class AnalyticsController {
  public static async trackEvent(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { eventName, category, platform, appVersion, metadata } = req.body;
      const result = await AnalyticsService.recordEvent({
        userId: req.user?.userId,
        eventName: eventName || 'CUSTOM_EVENT',
        category: category || 'GENERAL',
        platform: platform || 'android',
        appVersion,
        metadata,
        ipAddress: req.ip || (req.headers['x-forwarded-for'] as string),
        userAgent: req.headers['user-agent'],
      });
      sendCreated(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async getSummary(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AnalyticsService.getSummary();
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }
}
