import { Redis } from 'ioredis';
import { env } from './env.js';
import { logger } from './logger.js';

const redisUrl = env.REDIS_URL || `redis://${env.REDIS_HOST}:${env.REDIS_PORT}`;

export const redis = new Redis(redisUrl, {
  password: env.REDIS_PASSWORD || undefined,
  maxRetriesPerRequest: 1,
  enableReadyCheck: false,
  enableOfflineQueue: false,
  lazyConnect: true,
  retryStrategy(times) {
    if (env.NODE_ENV === 'test' || times > 3) {
      return null;
    }
    const delay = Math.min(times * 200, 2000);
    logger.warn({ attempt: times, delayMs: delay }, 'Retrying Redis connection...');
    return delay;
  },
});

// Always attach an error listener to prevent Node unhandled error events
redis.on('error', (err) => {
  if (env.NODE_ENV !== 'test') {
    logger.error({ error: err.message }, '❌ Redis connection error');
  }
});

if (env.NODE_ENV !== 'test') {
  redis.on('connect', () => {
    logger.info('⚡ Redis connection initialized');
  });

  redis.on('ready', () => {
    logger.info('✅ Redis client ready');
  });

  redis.on('close', () => {
    logger.warn('🔌 Redis connection closed');
  });
}

export async function checkRedisHealth(): Promise<{ status: 'connected' | 'disconnected'; latencyMs: number }> {
  const start = Date.now();
  try {
    const pong = await redis.ping();
    if (pong === 'PONG') {
      return { status: 'connected', latencyMs: Date.now() - start };
    }
    return { status: 'disconnected', latencyMs: Date.now() - start };
  } catch (error) {
    if (env.NODE_ENV !== 'test') {
      logger.error({ error }, 'Redis health check failed');
    }
    return { status: 'disconnected', latencyMs: Date.now() - start };
  }
}
