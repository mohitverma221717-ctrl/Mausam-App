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

  type PrismaEventClient = PrismaClient & {
    $on(event: 'query', cb: (e: { query: string; params: string; duration: number }) => void): void;
    $on(event: 'error', cb: (e: { message: string }) => void): void;
  };

  const eventClient = client as unknown as PrismaEventClient;

  if (env.NODE_ENV === 'development') {
    eventClient.$on('query', (e: { query: string; params: string; duration: number }) => {
      logger.debug({ query: e.query, params: e.params, duration: `${e.duration}ms` }, 'Prisma Query');
    });
  }

  eventClient.$on('error', (e: { message: string }) => {
    logger.error({ error: e.message }, 'Prisma Error');
  });

  return client;
};

declare global {
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
