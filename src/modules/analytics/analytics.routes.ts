import { Router } from 'express';
import { AnalyticsController } from './analytics.controller.js';
import { optionalAuthenticate, authenticate } from '@core/middleware/auth.middleware.js';
import { requireRole } from '@core/middleware/role.middleware.js';

export const analyticsRouter = Router();

analyticsRouter.post('/events', optionalAuthenticate, AnalyticsController.trackEvent);
analyticsRouter.get('/summary', authenticate, requireRole('ADMIN', 'SUPER_ADMIN'), AnalyticsController.getSummary);
