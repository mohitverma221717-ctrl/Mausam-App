import { Router } from 'express';
import { NotificationController } from './notification.controller.js';
import { authenticate } from '@core/middleware/auth.middleware.js';

export const notificationRouter = Router();

notificationRouter.use(authenticate);

notificationRouter.get('/', NotificationController.getList);
notificationRouter.patch('/:id/read', NotificationController.markRead);
notificationRouter.patch('/read-all', NotificationController.markAllRead);
notificationRouter.post('/device-token', NotificationController.registerDevice);
