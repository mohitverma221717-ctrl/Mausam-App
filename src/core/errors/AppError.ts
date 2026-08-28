import { ErrorCode, ErrorCodes } from './ErrorCodes.js';

export class AppError extends Error {
  public readonly statusCode: number;
  public readonly code: ErrorCode;
  public readonly isOperational: boolean;
  public readonly details?: unknown;

  constructor(
    message: string,
    statusCode = 500,
    code: ErrorCode = ErrorCodes.INTERNAL_SERVER_ERROR,
    isOperational = true,
    details?: unknown,
  ) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = isOperational;
    this.details = details;
    Object.setPrototypeOf(this, new.target.prototype);
    Error.captureStackTrace(this, this.constructor);
  }

  static badRequest(message: string, code: ErrorCode = ErrorCodes.BAD_REQUEST, details?: unknown) {
    return new AppError(message, 400, code, true, details);
  }

  static validation(message: string, details?: unknown) {
    return new AppError(message, 422, ErrorCodes.VALIDATION_ERROR, true, details);
  }

  static unauthorized(message = 'Unauthorized access', code: ErrorCode = ErrorCodes.UNAUTHORIZED) {
    return new AppError(message, 401, code, true);
  }

  static forbidden(message = 'Access forbidden', code: ErrorCode = ErrorCodes.FORBIDDEN) {
    return new AppError(message, 403, code, true);
  }

  static notFound(message = 'Resource not found', code: ErrorCode = ErrorCodes.NOT_FOUND) {
    return new AppError(message, 404, code, true);
  }

  static conflict(message: string, code: ErrorCode = ErrorCodes.DUPLICATE_ENTRY) {
    return new AppError(message, 409, code, true);
  }

  static rateLimit(message = 'Too many requests, please try again later') {
    return new AppError(message, 429, ErrorCodes.RATE_LIMIT_EXCEEDED, true);
  }

  static internal(message = 'Internal server error', details?: unknown) {
    return new AppError(message, 500, ErrorCodes.INTERNAL_SERVER_ERROR, false, details);
  }

  static external(message: string, code: ErrorCode = ErrorCodes.EXTERNAL_API_ERROR, details?: unknown) {
    return new AppError(message, 502, code, true, details);
  }
}
