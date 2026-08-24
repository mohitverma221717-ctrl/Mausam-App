import { Request, Response, NextFunction } from 'express';
import { JwtUtil, TokenPayload } from '@core/security/jwt.js';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';

declare global {
  namespace Express {
    interface Request {
      user?: TokenPayload;
    }
  }
}

export function authenticate(req: Request, _res: Response, next: NextFunction): void {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(new AppError('Authorization token required', 401, ErrorCodes.UNAUTHORIZED));
  }

  const token = authHeader.split(' ')[1];
  if (!token) {
    return next(new AppError('Authorization token required', 401, ErrorCodes.UNAUTHORIZED));
  }

  try {
    const payload = JwtUtil.verifyAccessToken(token);
    req.user = payload;
    next();
  } catch (error) {
    next(error);
  }
}

export function optionalAuthenticate(req: Request, _res: Response, next: NextFunction): void {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next();
  }
  const token = authHeader.split(' ')[1];
  if (!token) return next();

  try {
    const payload = JwtUtil.verifyAccessToken(token);
    req.user = payload;
  } catch {
    // Ignore error for optional auth
  }
  next();
}
