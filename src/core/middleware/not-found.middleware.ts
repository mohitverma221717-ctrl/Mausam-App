import { Request, Response, NextFunction } from 'express';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';

export function notFoundHandler(req: Request, _res: Response, next: NextFunction): void {
  next(
    new AppError(
      `Route ${req.method} ${req.originalUrl} not found`,
      404,
      ErrorCodes.ROUTE_NOT_FOUND,
    ),
  );
}
