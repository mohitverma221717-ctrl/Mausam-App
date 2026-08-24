import { Router } from 'express';
import { LocationController } from './location.controller.js';
import { authenticate } from '@core/middleware/auth.middleware.js';
import { validate } from '@core/middleware/validation.middleware.js';
import {
  searchLocationSchema,
  nearbyLocationSchema,
  saveLocationSchema,
  favoriteLocationSchema,
} from './location.schema.js';

export const locationRouter = Router();

// Public Location Lookups
locationRouter.get('/search', validate({ query: searchLocationSchema }), LocationController.search);
locationRouter.get('/nearby', validate({ query: nearbyLocationSchema }), LocationController.nearby);
locationRouter.get('/:id', LocationController.getById);

// Authenticated User Saved & Favorites
locationRouter.get('/user/saved', authenticate, LocationController.getSaved);
locationRouter.post('/user/saved', authenticate, validate({ body: saveLocationSchema }), LocationController.saveLocation);
locationRouter.delete('/user/saved/:locationId', authenticate, LocationController.removeSaved);

locationRouter.get('/user/favorites', authenticate, LocationController.getFavorites);
locationRouter.post('/user/favorites', authenticate, validate({ body: favoriteLocationSchema }), LocationController.addFavorite);
locationRouter.delete('/user/favorites/:locationId', authenticate, LocationController.removeFavorite);
