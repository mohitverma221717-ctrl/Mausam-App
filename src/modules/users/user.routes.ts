import { Router } from 'express';
import { UserController } from './user.controller.js';
import { authenticate } from '@core/middleware/auth.middleware.js';
import { validate } from '@core/middleware/validation.middleware.js';
import { updateProfileSchema, updatePreferencesSchema, addInterestSchema } from './user.schema.js';

export const userRouter = Router();

userRouter.use(authenticate);

userRouter.get('/profile', UserController.getProfile);
userRouter.patch('/profile', validate({ body: updateProfileSchema }), UserController.updateProfile);

userRouter.get('/preferences', UserController.getPreferences);
userRouter.patch('/preferences', validate({ body: updatePreferencesSchema }), UserController.updatePreferences);

userRouter.get('/interests', UserController.getInterests);
userRouter.post('/interests', validate({ body: addInterestSchema }), UserController.addInterest);
userRouter.delete('/interests/:interest', UserController.removeInterest);
