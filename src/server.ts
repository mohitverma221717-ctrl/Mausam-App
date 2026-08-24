import http from 'http';
import { createApp } from './app.js';
import { env } from '@config/env.js';
import { logger } from '@config/logger.js';
import { prisma } from '@config/database.js';
import { redis } from '@config/redis.js';
import { setupWorkers } from '@queues/queue.manager.js';
import { handleUncaughtException, handleUnhandledRejection } from '@core/errors/error-handler.js';

process.on('uncaughtException', handleUncaughtException);
process.on('unhandledRejection', handleUnhandledRejection);

const app = createApp();
const server = http.createServer(app);

async function startServer(): Promise<void> {
  try {
    // Attempt Redis connection
    if (redis.status === 'wait') {
      try {
        await redis.connect();
        logger.info('⚡ Connected to Redis successfully');
      } catch (redisErr: any) {
        logger.warn({ err: redisErr?.message }, '⚠️ Redis operating in degraded/offline mode');
      }
    }

    // Attempt Database connection
    try {
      await prisma.$connect();
      logger.info('🐘 Connected to PostgreSQL via Prisma');
    } catch (dbErr: any) {
      logger.warn({ err: dbErr?.message }, '⚠️ Database connection deferred - server operating in standalone mode');
    }

    // Setup background workers if Redis is available
    if (redis.status === 'ready' || redis.status === 'connecting') {
      setupWorkers();
    }

    server.listen(env.PORT, () => {
      logger.info(`🚀 Mausam Backend Server running on port ${env.PORT} [${env.NODE_ENV}]`);
      logger.info(`🌐 Health check endpoint: http://localhost:${env.PORT}${env.API_PREFIX}/health`);
      logger.info(`📱 Personalized Homepage: http://localhost:${env.PORT}${env.API_PREFIX}/home`);
    });
  } catch (error) {
    logger.fatal({ error }, 'Failed to start server');
    process.exit(1);
  }
}

// Graceful shutdown handling
const shutdown = async (signal: string): Promise<void> => {
  logger.info(`🛑 Received ${signal}. Starting graceful shutdown...`);

  server.close(async () => {
    logger.info('🔌 HTTP server closed');

    try {
      await prisma.$disconnect();
      logger.info('🐘 Prisma client disconnected');
    } catch {
      // Ignore error
    }

    try {
      redis.disconnect();
      logger.info('⚡ Redis client disconnected');
    } catch {
      // Ignore error
    }

    logger.info('👋 Server shutdown complete');
    process.exit(0);
  });

  setTimeout(() => {
    logger.error('⏰ Shutdown timed out. Forcing process exit.');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

void startServer();
