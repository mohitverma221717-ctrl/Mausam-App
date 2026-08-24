import { Router } from 'express';
import { EnvironmentController } from './environment.controller.js';

export const environmentRouter = Router();

environmentRouter.get('/report', EnvironmentController.getFullReport);
environmentRouter.get('/aqi', EnvironmentController.getAQI);
environmentRouter.get('/uv', EnvironmentController.getUV);
environmentRouter.get('/pollen', EnvironmentController.getPollen);
environmentRouter.get('/visibility', EnvironmentController.getVisibility);
