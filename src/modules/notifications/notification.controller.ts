import { Request, Response, NextFunction } from 'express';
import { NotificationService } from './notification.service.js';
import { sendSuccess } from '@core/utils/response.js';

export class NotificationController {
  public static async getList(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await NotificationService.getUserNotifications(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async markRead(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await NotificationService.markAsRead(req.user!.userId, req.params.id);
      sendSuccess(res, { message: 'Notification marked as read' });
    } catch (error) {
      next(error);
    }
  }

  public static async markAllRead(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await NotificationService.markAllAsRead(req.user!.userId);
      sendSuccess(res, { message: 'All notifications marked as read' });
    } catch (error) {
      next(error);
    }
  }

  public static async registerDevice(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { token, platform } = req.body;
      const result = await NotificationService.registerDeviceToken(
        req.user!.userId,
        token,
        platform || 'android',
      );
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }
}
