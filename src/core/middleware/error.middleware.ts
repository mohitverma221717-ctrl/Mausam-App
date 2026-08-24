import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';
import { logger } from '@config/logger.js';
import { env } from '@config/env.js';
import { sendError } from '@core/utils/response.js';

export function errorHandler(
  err: Error | AppError,
  req: Request,
  res: Response,
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  _next: NextFunction,
): void {
  const requestId = (req.headers['x-request-id'] as string) || 'unknown';

  // 1. Handle Known AppError
  if (err instanceof AppError) {
    if (!err.isOperational) {
      logger.error({ requestId, err, stack: err.stack }, 'Non-operational AppError occurred');
    } else {
      logger.warn({ requestId, code: err.code, message: err.message }, 'Operational error handled');
    }
    sendError(res, err.statusCode, err.code, err.message, err.details, requestId);
    return;
  }

  // 2. Handle Zod Validation Errors
  if (err instanceof ZodError) {
    const formattedErrors = err.errors.map((e) => ({
      field: e.path.join('.'),
      message: e.message,
    }));
    logger.warn({ requestId, validationErrors: formattedErrors }, 'Zod validation error');
    sendError(
      res,
      422,
      ErrorCodes.VALIDATION_ERROR,
      'Input validation failed',
      formattedErrors,
      requestId,
    );
    return;
  }

  // 3. Handle JSON syntax errors in request body
  if (err instanceof SyntaxError && 'status' in err && (err as { status: number }).status === 400) {
    logger.warn({ requestId, message: err.message }, 'Malformed JSON in request');
    sendError(res, 400, ErrorCodes.BAD_REQUEST, 'Malformed JSON payload', undefined, requestId);
    return;
  }

  // 4. Handle Prisma Errors
  if (err.name === 'PrismaClientKnownRequestError') {
    const prismaErr = err as unknown as { code: string; meta?: Record<string, unknown> };
    if (prismaErr.code === 'P2002') {
      const target = prismaErr.meta?.target || 'field';
      sendError(
        res,
        409,
        ErrorCodes.DUPLICATE_ENTRY,
        `Duplicate value for unique field: ${target}`,
        undefined,
        requestId,
      );
      return;
    }
    if (prismaErr.code === 'P2025') {
      sendError(res, 404, ErrorCodes.RECORD_NOT_FOUND, 'Requested record was not found', undefined, requestId);
      return;
    }
  }

  // 5. Handle Unhandled / Internal Errors
  logger.error({ requestId, message: err.message, stack: err.stack }, '💥 Unhandled Server Error');

  const message = env.NODE_ENV === 'production' ? 'Internal server error' : err.message;
  const details = env.NODE_ENV === 'production' ? undefined : { stack: err.stack };

  sendError(res, 500, ErrorCodes.INTERNAL_SERVER_ERROR, message, details, requestId);
}
