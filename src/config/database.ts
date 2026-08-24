import { PrismaClient } from '@prisma/client';
import { env } from './env.js';
import { logger } from './logger.js';

const prismaClientSingleton = () => {
  const client = new PrismaClient({
    log:
      env.NODE_ENV === 'development'
        ? [
            { emit: 'event', level: 'query' },
            { emit: 'event', level: 'error' },
            { emit: 'event', level: 'info' },
            { emit: 'event', level: 'warn' },
          ]
        : [{ emit: 'event', level: 'error' }],
  });

  if (env.NODE_ENV === 'development') {
    (client as any).$on('query', (e: { query: string; params: string; duration: number }) => {
      logger.debug({ query: e.query, params: e.params, duration: `${e.duration}ms` }, 'Prisma Query');
    });
  }

  (client as any).$on('error', (e: { message: string }) => {
    logger.error({ error: e.message }, 'Prisma Error');
  });

  return client;
};

declare global {
  // eslint-disable-next-line no-var
  var prismaGlobal: ReturnType<typeof prismaClientSingleton> | undefined;
}

export const prisma = globalThis.prismaGlobal ?? prismaClientSingleton();

if (env.NODE_ENV !== 'production') {
  globalThis.prismaGlobal = prisma;
}

export async function checkDatabaseHealth(): Promise<{ status: 'connected' | 'disconnected'; latencyMs: number }> {
  const start = Date.now();
  try {
    await prisma.$queryRaw`SELECT 1`;
    return { status: 'connected', latencyMs: Date.now() - start };
  } catch (error) {
    logger.error({ error }, 'Database health check failed');
    return { status: 'disconnected', latencyMs: Date.now() - start };
  }
}
