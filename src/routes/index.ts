import { Router } from 'express';
import { systemRouter } from '@modules/system/system.routes.js';
import { authRouter } from '@modules/auth/auth.routes.js';
import { userRouter } from '@modules/users/user.routes.js';
import { locationRouter } from '@modules/locations/location.routes.js';
import { weatherRouter } from '@modules/weather/weather.routes.js';
import { environmentRouter } from '@modules/environment/environment.routes.js';
import { personalizationRouter } from '@modules/personalization/personalization.routes.js';
import { recommendationRouter } from '@modules/recommendations/recommendation.routes.js';
import { alertRouter } from '@modules/alerts/alert.routes.js';
import { notificationRouter } from '@modules/notifications/notification.routes.js';
import { domainsRouter } from '@modules/domains/domains.routes.js';
import { adminRouter } from '@modules/admin/admin.routes.js';
import { analyticsRouter } from '@modules/analytics/analytics.routes.js';

export const router = Router();

// System Health & Monitoring
router.use('/', systemRouter);

// Domain Routes
router.use('/auth', authRouter);
router.use('/users', userRouter);
router.use('/locations', locationRouter);
router.use('/weather', weatherRouter);
router.use('/environment', environmentRouter);
router.use('/home', personalizationRouter);
router.use('/recommendations', recommendationRouter);
router.use('/alerts', alertRouter);
router.use('/notifications', notificationRouter);
router.use('/domains', domainsRouter);
router.use('/admin', adminRouter);
router.use('/analytics', analyticsRouter);
