import { Router } from 'express';
import { DomainsController } from './domains.controller.js';
import { authenticate } from '@core/middleware/auth.middleware.js';

export const domainsRouter = Router();

// Public / Location-based domain feeds
domainsRouter.get('/marine', DomainsController.getMarine);
domainsRouter.get('/fitness', DomainsController.getFitness);

// Authenticated user domain profiles
domainsRouter.get('/agriculture/farms', authenticate, DomainsController.getFarms);
domainsRouter.post('/agriculture/farms', authenticate, DomainsController.createFarm);

domainsRouter.get('/travel/trips', authenticate, DomainsController.getTrips);
domainsRouter.get('/family', authenticate, DomainsController.getFamily);
domainsRouter.get('/commute', authenticate, DomainsController.getCommute);
domainsRouter.get('/events', authenticate, DomainsController.getEvents);
