import { Request, Response, NextFunction } from 'express';
import { WeatherService } from './weather.service.js';
import { LocationService } from '@modules/locations/location.service.js';
import { sendSuccess } from '@core/utils/response.js';

export class WeatherController {
  public static async getCurrent(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await WeatherController.extractCoordinates(req);
      const data = await WeatherService.getCurrentWeather(lat, lon);
      sendSuccess(res, data);
    } catch (error) {
      next(error);
    }
  }

  public static async getForecast(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await WeatherController.extractCoordinates(req);
      const data = await WeatherService.getFullForecast(lat, lon);
      sendSuccess(res, data);
    } catch (error) {
      next(error);
    }
  }

  public static async getHourly(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await WeatherController.extractCoordinates(req);
      const data = await WeatherService.getFullForecast(lat, lon);
      sendSuccess(res, data.hourly);
    } catch (error) {
      next(error);
    }
  }

  public static async getDaily(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { lat, lon } = await WeatherController.extractCoordinates(req);
      const data = await WeatherService.getFullForecast(lat, lon);
      sendSuccess(res, data.daily);
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

    // Default to New Delhi (Safdarjung)
    return { lat: 28.5847, lon: 77.2066 };
  }
}
