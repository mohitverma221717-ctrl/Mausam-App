import { Request, Response, NextFunction } from 'express';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';

export function requireRole(...allowedRoles: string[]) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    if (!req.user) {
      return next(new AppError('Authentication required', 401, ErrorCodes.UNAUTHORIZED));
    }

    const hasRole = req.user.roles.some((role) => allowedRoles.includes(role));

    if (!hasRole) {
      return next(
        new AppError(
          `Forbidden: Requires one of [${allowedRoles.join(', ')}] role`,
          403,
          ErrorCodes.FORBIDDEN,
        ),
      );
    }

    next();
  };
}
