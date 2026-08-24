import { Request, Response, NextFunction } from 'express';
import { checkDatabaseHealth } from '@config/database.js';
import { checkRedisHealth } from '@config/redis.js';
import { sendSuccess } from '@core/utils/response.js';

export class SystemController {
  public static async getHealth(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const [dbHealth, redisHealth] = await Promise.all([
        checkDatabaseHealth(),
        checkRedisHealth(),
      ]);

      const uptimeSeconds = process.uptime();
      const memoryUsage = process.memoryUsage();

      const isHealthy = dbHealth.status === 'connected' && redisHealth.status === 'connected';

      const healthData = {
        status: isHealthy ? 'healthy' : 'degraded',
        service: 'mausam-backend',
        version: '1.0.0',
        timestamp: new Date().toISOString(),
        uptime: `${Math.floor(uptimeSeconds / 60)}m ${Math.floor(uptimeSeconds % 60)}s`,
        system: {
          nodeVersion: process.version,
          platform: process.platform,
          memory: {
            rssMb: Math.round(memoryUsage.rss / 1024 / 1024),
            heapUsedMb: Math.round(memoryUsage.heapUsed / 1024 / 1024),
            heapTotalMb: Math.round(memoryUsage.heapTotal / 1024 / 1024),
          },
        },
        services: {
          database: {
            provider: 'PostgreSQL',
            ...dbHealth,
          },
          cache: {
            provider: 'Redis',
            ...redisHealth,
          },
        },
      };

      sendSuccess(res, healthData, isHealthy ? 200 : 503);
    } catch (error) {
      next(error);
    }
  }

  public static getPing(_req: Request, res: Response): void {
    sendSuccess(res, { message: 'pong', timestamp: new Date().toISOString() });
  }
}
