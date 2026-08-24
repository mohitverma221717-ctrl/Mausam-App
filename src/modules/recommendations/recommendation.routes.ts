import { Router } from 'express';
import { RecommendationController } from './recommendation.controller.js';
import { optionalAuthenticate, authenticate } from '@core/middleware/auth.middleware.js';

export const recommendationRouter = Router();

recommendationRouter.get('/', optionalAuthenticate, RecommendationController.getRecommendations);
recommendationRouter.post('/interact', authenticate, RecommendationController.recordInteraction);
