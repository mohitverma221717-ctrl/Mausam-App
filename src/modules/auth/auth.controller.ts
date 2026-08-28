import { Request, Response, NextFunction } from 'express';
import { AuthService } from './auth.service.js';
import { sendSuccess, sendCreated } from '@core/utils/response.js';

export class AuthController {
  public static async register(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.register(req.body);
      sendCreated(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const metadata = {
        ipAddress: req.ip || (req.headers['x-forwarded-for'] as string),
        userAgent: req.headers['user-agent'],
      };
      const result = await AuthService.login(req.body, metadata);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async refresh(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.refreshToken(req.body.refreshToken);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async logout(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.logout(req.body.refreshToken);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async getMe(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.getCurrentUser(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async changePassword(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await AuthService.changePassword(req.user!.userId, req.body);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }
}
