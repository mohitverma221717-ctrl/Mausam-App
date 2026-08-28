import { Request, Response, NextFunction } from 'express';
import { DomainsService } from './domains.service.js';
import { sendSuccess, sendCreated } from '@core/utils/response.js';

export class DomainsController {
  // Agriculture
  public static async getFarms(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await DomainsService.getFarms(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async createFarm(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await DomainsService.createFarm(req.user!.userId, req.body);
      sendCreated(res, result);
    } catch (error) {
      next(error);
    }
  }

  // Marine
  public static async getMarine(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const lat = parseFloat((req.query.latitude as string) || '18.9067');
      const lon = parseFloat((req.query.longitude as string) || '72.8147');
      const result = await DomainsService.getMarineConditions(lat, lon);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  // Fitness
  public static async getFitness(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const lat = parseFloat((req.query.latitude as string) || '28.5847');
      const lon = parseFloat((req.query.longitude as string) || '77.2066');
      const result = await DomainsService.getFitnessScore(lat, lon);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  // Travel
  public static async getTrips(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await DomainsService.getTrips(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  // Family
  public static async getFamily(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await DomainsService.getFamilyProfile(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  // Commute
  public static async getCommute(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await DomainsService.getCommuteRoutes(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  // Events
  public static async getEvents(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await DomainsService.getOutdoorEvents(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }
}
