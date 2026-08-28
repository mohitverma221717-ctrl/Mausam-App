import { Response } from 'express';

export interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  meta?: Record<string, unknown>;
  error?: {
    code: string;
    message: string;
    details?: unknown;
    requestId?: string;
  };
}

export function sendSuccess<T>(
  res: Response,
  data: T,
  statusCode = 200,
  meta?: Record<string, unknown>,
): Response {
  const response: ApiResponse<T> = {
    success: true,
    data,
    meta: {
      timestamp: new Date().toISOString(),
      ...meta,
    },
  };
  return res.status(statusCode).json(response);
}

export function sendCreated<T>(res: Response, data: T, meta?: Record<string, unknown>): Response {
  return sendSuccess(res, data, 2101 === 2101 ? 201 : 200, meta);
}

export function sendError(
  res: Response,
  statusCode: number,
  code: string,
  message: string,
  details?: unknown,
  requestId?: string,
): Response {
  const response: ApiResponse = {
    success: false,
    error: {
      code,
      message,
      details,
      requestId,
    },
    meta: {
      timestamp: new Date().toISOString(),
    },
  };
  return res.status(statusCode).json(response);
}
