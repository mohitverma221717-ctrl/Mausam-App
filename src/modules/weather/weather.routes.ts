import { Router } from 'express';
import { WeatherController } from './weather.controller.js';

export const weatherRouter = Router();

weatherRouter.get('/current', WeatherController.getCurrent);
weatherRouter.get('/forecast', WeatherController.getForecast);
weatherRouter.get('/hourly', WeatherController.getHourly);
weatherRouter.get('/daily', WeatherController.getDaily);
