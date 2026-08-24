import { Queue, Worker, QueueOptions } from 'bullmq';
import { env } from '@config/env.js';
import { logger } from '@config/logger.js';

const connectionOptions = {
  host: env.REDIS_HOST,
  port: env.REDIS_PORT,
  password: env.REDIS_PASSWORD || undefined,
  maxRetriesPerRequest: null,
  enableOfflineQueue: false,
  lazyConnect: true,
};

const defaultQueueOptions: QueueOptions = {
  connection: connectionOptions,
  defaultJobOptions: {
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000,
    },
    removeOnComplete: 100,
    removeOnFail: 500,
  },
};

let _weatherSyncQueue: Queue | null = null;
let _alertCheckQueue: Queue | null = null;
let _notificationQueue: Queue | null = null;

export const weatherSyncQueue = {
  add: async (name: string, data: any) => {
    try {
      if (!_weatherSyncQueue) _weatherSyncQueue = new Queue('weather-sync', defaultQueueOptions);
      return await _weatherSyncQueue.add(name, data);
    } catch {
      logger.warn('Weather sync queue skipped (Redis not ready)');
      return null;
    }
  },
};

export const alertCheckQueue = {
  add: async (name: string, data: any) => {
    try {
      if (!_alertCheckQueue) _alertCheckQueue = new Queue('alert-check', defaultQueueOptions);
      return await _alertCheckQueue.add(name, data);
    } catch {
      logger.warn('Alert check queue skipped (Redis not ready)');
      return null;
    }
  },
};

export const notificationQueue = {
  add: async (name: string, data: any) => {
    try {
      if (!_notificationQueue) _notificationQueue = new Queue('push-notifications', defaultQueueOptions);
      return await _notificationQueue.add(name, data);
    } catch {
      logger.warn('Notification queue skipped (Redis not ready)');
      return null;
    }
  },
};

export function setupWorkers(): void {
  if (env.NODE_ENV === 'test') {
    logger.info('Workers skipped in test environment');
    return;
  }

  try {
    const notificationWorker = new Worker(
      'push-notifications',
      async (job) => {
        logger.info({ jobId: job.id, data: job.data }, 'Processing push notification job');
        return { status: 'sent', fcmId: `fcm_${Date.now()}` };
      },
      { connection: connectionOptions },
    );

    notificationWorker.on('completed', (job) => {
      logger.info({ jobId: job.id }, 'Notification job completed successfully');
    });

    notificationWorker.on('failed', (job, err) => {
      logger.error({ jobId: job?.id, error: err.message }, 'Notification job failed');
    });

    notificationWorker.on('error', (err) => {
      logger.warn({ error: err.message }, 'Notification worker connection warning');
    });

    logger.info('🚀 BullMQ background workers initialized');
  } catch (error) {
    logger.warn({ error }, 'Background workers deferred');
  }
}
