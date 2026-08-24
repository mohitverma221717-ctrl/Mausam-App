import { Request, Response, NextFunction } from 'express';
import { UserService } from './user.service.js';
import { sendSuccess } from '@core/utils/response.js';

export class UserController {
  public static async getProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UserService.getProfile(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async updateProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UserService.updateProfile(req.user!.userId, req.body);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async getPreferences(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UserService.getPreferences(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async updatePreferences(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UserService.updatePreferences(req.user!.userId, req.body);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async getInterests(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UserService.getInterests(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async addInterest(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UserService.addInterest(req.user!.userId, req.body);
      sendSuccess(res, result, 201);
    } catch (error) {
      next(error);
    }
  }

  public static async removeInterest(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await UserService.removeInterest(req.user!.userId, req.params.interest);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }
}
