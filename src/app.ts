import express, { Application } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import { env } from '@config/env.js';
import { requestIdMiddleware } from '@core/middleware/request-id.middleware.js';
import { apiRateLimiter } from '@core/middleware/rate-limit.middleware.js';
import { errorHandler } from '@core/middleware/error.middleware.js';
import { notFoundHandler } from '@core/middleware/not-found.middleware.js';
import { router } from '@routes/index.js';

export function createApp(): Application {
  const app = express();

  // Security headers
  app.use(
    helmet({
      contentSecurityPolicy: env.NODE_ENV === 'production',
      crossOriginEmbedderPolicy: false,
    }),
  );

  // CORS Configuration
  app.use(
    cors({
      origin: env.CORS_ORIGIN === '*' ? '*' : env.CORS_ORIGIN.split(','),
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-Id'],
    }),
  );

  // Request correlation ID
  app.use(requestIdMiddleware);

  // Compression & Body parsers
  app.use(compression());
  app.use(express.json({ limit: '10mb' }));
  app.use(express.urlencoded({ extended: true, limit: '10mb' }));

  // Global API Rate limiter
  app.use(env.API_PREFIX, apiRateLimiter);

  // Mount versioned API routes
  app.use(env.API_PREFIX, router);

  // Root redirect/fallback
  app.get('/', (_req, res) => {
    res.json({
      name: 'Mausam Backend API',
      version: '1.0.0',
      description: 'Ministry of Earth Sciences (MoES) / IMD - SIH 26076',
      documentation: `${env.API_PREFIX}/docs`,
      health: `${env.API_PREFIX}/health`,
    });
  });

  // 404 handler
  app.use(notFoundHandler);

  // Centralized Error handler
  app.use(errorHandler);

  return app;
}
