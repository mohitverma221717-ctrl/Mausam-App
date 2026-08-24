import { Router } from 'express';
import { PersonalizationController } from './personalization.controller.js';
import { optionalAuthenticate } from '@core/middleware/auth.middleware.js';

export const personalizationRouter = Router();

// GET /api/v1/home (Supports both authenticated personalized requests & guest requests)
personalizationRouter.get('/', optionalAuthenticate, PersonalizationController.getHomepage);
