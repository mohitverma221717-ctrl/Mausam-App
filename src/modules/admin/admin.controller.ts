import { Request, Response, NextFunction } from 'express';
import { AdminService } from './admin.service.js';
import { sendSuccess } from '@core/utils/response.js';

export class AdminController {
  public static async getDashboard(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const stats = await AdminService.getDashboardStats();
      sendSuccess(res, stats);
    } catch (error) {
      next(error);
    }
  }

  public static async getUsers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const users = await AdminService.getUsers(req.query);
      sendSuccess(res, users.items, 200, users.pagination);
    } catch (error) {
      next(error);
    }
  }

  public static async getRules(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const rules = await AdminService.getPersonalizationRules();
      sendSuccess(res, rules);
    } catch (error) {
      next(error);
    }
  }

  public static async updateCardPriority(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { personaType, cardType, basePriority, weightMultiplier } = req.body;
      const result = await AdminService.updateCardPriority(
        req.user!.userId,
        personaType,
        cardType,
        basePriority,
        weightMultiplier || 1.0,
      );
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async getSettings(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const settings = await AdminService.getSystemSettings();
      sendSuccess(res, settings);
    } catch (error) {
      next(error);
    }
  }

  public static async updateSetting(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { key, value } = req.body;
      const result = await AdminService.updateSystemSetting(req.user!.userId, key, value);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }
}
