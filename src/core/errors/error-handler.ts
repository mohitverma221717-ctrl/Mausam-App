import { logger } from '@config/logger.js';
import { AppError } from './AppError.js';

export function handleUncaughtException(error: Error): void {
  logger.fatal({ error: error.message, stack: error.stack }, '💥 Uncaught Exception! Shutting down process...');
  process.exit(1);
}

export function handleUnhandledRejection(reason: unknown): void {
  logger.error({ reason }, '⚠️ Unhandled Promise Rejection recorded');
}

export function isOperationalError(error: Error): boolean {
  if (error instanceof AppError) {
    return error.isOperational;
  }
  return false;
}
