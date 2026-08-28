import { Request, Response, NextFunction } from 'express';
import { LocationService } from './location.service.js';
import { sendSuccess, sendCreated } from '@core/utils/response.js';

export class LocationController {
  public static async search(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const query = req.query.query as string;
      const locations = await LocationService.searchLocations(query);
      sendSuccess(res, locations);
    } catch (error) {
      next(error);
    }
  }

  public static async nearby(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const lat = parseFloat(req.query.latitude as string);
      const lon = parseFloat(req.query.longitude as string);
      const radiusKm = parseFloat((req.query.radiusKm as string) || '50');

      const locations = await LocationService.getNearbyLocations(lat, lon, radiusKm);
      sendSuccess(res, locations);
    } catch (error) {
      next(error);
    }
  }

  public static async getById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const location = await LocationService.getLocationById(req.params.id);
      sendSuccess(res, location);
    } catch (error) {
      next(error);
    }
  }

  public static async getSaved(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await LocationService.getSavedLocations(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async saveLocation(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await LocationService.saveLocation(req.user!.userId, req.body);
      sendCreated(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async removeSaved(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await LocationService.removeSavedLocation(req.user!.userId, req.params.locationId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async getFavorites(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await LocationService.getFavoriteLocations(req.user!.userId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async addFavorite(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await LocationService.addFavoriteLocation(req.user!.userId, req.body);
      sendCreated(res, result);
    } catch (error) {
      next(error);
    }
  }

  public static async removeFavorite(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await LocationService.removeFavoriteLocation(req.user!.userId, req.params.locationId);
      sendSuccess(res, result);
    } catch (error) {
      next(error);
    }
  }
}
