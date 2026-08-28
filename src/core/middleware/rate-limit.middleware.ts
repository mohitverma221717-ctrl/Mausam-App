import rateLimit from 'express-rate-limit';
import { RedisStore } from 'rate-limit-redis';
import { env } from '@config/env.js';
import { redis } from '@config/redis.js';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';

function createRedisStore(prefix: string) {
  if (env.NODE_ENV === 'test' || redis.status !== 'ready') {
    return undefined; // Use memory store when Redis is offline or testing
  }
  try {
    return new RedisStore({
      // @ts-expect-error ioredis sendCommand compatibility
      sendCommand: (...args: string[]) => redis.call(...args),
      prefix,
    });
  } catch {
    return undefined;
  }
}

export const apiRateLimiter = rateLimit({
  windowMs: env.RATE_LIMIT_WINDOW_MS,
  max: env.NODE_ENV === 'test' ? 10000 : env.RATE_LIMIT_MAX,
  standardHeaders: true,
  legacyHeaders: false,
  store: createRedisStore('rl:api:'),
  handler: (_req, _res, next) => {
    next(new AppError('Too many requests, please try again later.', 429, ErrorCodes.RATE_LIMIT_EXCEEDED));
  },
});

export const authRateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: env.NODE_ENV === 'test' ? 10000 : 20,
  standardHeaders: true,
  legacyHeaders: false,
  store: createRedisStore('rl:auth:'),
  handler: (_req, _res, next) => {
    next(new AppError('Too many authentication attempts, please try again in 15 minutes.', 429, ErrorCodes.RATE_LIMIT_EXCEEDED));
  },
});
