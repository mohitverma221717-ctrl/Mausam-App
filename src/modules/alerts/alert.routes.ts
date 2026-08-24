import { Router } from 'express';
import { AlertController } from './alert.controller.js';
import { authenticate } from '@core/middleware/auth.middleware.js';
import { requireRole } from '@core/middleware/role.middleware.js';

export const alertRouter = Router();

alertRouter.get('/active', AlertController.getActive);
alertRouter.get('/:id', AlertController.getById);

// Admin-only alert creation
alertRouter.post('/', authenticate, requireRole('ADMIN', 'SUPER_ADMIN'), AlertController.create);
