import { Router } from 'express';
import { AdminController } from './admin.controller.js';
import { authenticate } from '@core/middleware/auth.middleware.js';
import { requireRole } from '@core/middleware/role.middleware.js';

export const adminRouter = Router();

// Protect all admin routes with authentication and role check
adminRouter.use(authenticate, requireRole('ADMIN', 'SUPER_ADMIN'));

adminRouter.get('/dashboard', AdminController.getDashboard);
adminRouter.get('/users', AdminController.getUsers);
adminRouter.get('/personalization/rules', AdminController.getRules);
adminRouter.put('/personalization/card-priority', AdminController.updateCardPriority);
adminRouter.get('/system/settings', AdminController.getSettings);
adminRouter.put('/system/settings', AdminController.updateSetting);
