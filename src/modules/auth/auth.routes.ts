import { Router } from 'express';
import { AuthController } from './auth.controller.js';
import { validate } from '@core/middleware/validation.middleware.js';
import { authenticate } from '@core/middleware/auth.middleware.js';
import { authRateLimiter } from '@core/middleware/rate-limit.middleware.js';
import {
  registerSchema,
  loginSchema,
  refreshTokenSchema,
  changePasswordSchema,
} from './auth.schema.js';

export const authRouter = Router();

authRouter.post('/register', authRateLimiter, validate({ body: registerSchema }), AuthController.register);
authRouter.post('/login', authRateLimiter, validate({ body: loginSchema }), AuthController.login);
authRouter.post('/refresh', validate({ body: refreshTokenSchema }), AuthController.refresh);
authRouter.post('/logout', AuthController.logout);

authRouter.get('/me', authenticate, AuthController.getMe);
authRouter.post('/change-password', authenticate, validate({ body: changePasswordSchema }), AuthController.changePassword);
