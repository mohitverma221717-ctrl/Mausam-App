import { Router } from 'express';
import { SystemController } from './system.controller.js';

export const systemRouter = Router();

systemRouter.get('/health', SystemController.getHealth);
systemRouter.get('/ping', SystemController.getPing);
