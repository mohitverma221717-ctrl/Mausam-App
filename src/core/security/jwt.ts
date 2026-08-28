import jwt, { SignOptions } from 'jsonwebtoken';
import crypto from 'crypto';
import { env } from '@config/env.js';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';

export interface TokenPayload {
  userId: string;
  email: string;
  roles: string[];
}

export interface RefreshTokenPayload {
  userId: string;
  familyId: string;
  tokenId: string;
}

export class JwtUtil {
  public static generateAccessToken(payload: TokenPayload): string {
    const options: SignOptions = {
      expiresIn: env.JWT_EXPIRES_IN as unknown as number,
    };
    return jwt.sign(payload, env.JWT_SECRET, options);
  }

  public static generateRefreshToken(payload: RefreshTokenPayload): string {
    const options: SignOptions = {
      expiresIn: env.JWT_REFRESH_EXPIRES_IN as unknown as number,
    };
    return jwt.sign(payload, env.JWT_REFRESH_SECRET, options);
  }

  public static verifyAccessToken(token: string): TokenPayload {
    try {
      return jwt.verify(token, env.JWT_SECRET) as TokenPayload;
    } catch (error) {
      if (error instanceof jwt.TokenExpiredError) {
        throw new AppError('Access token has expired', 401, ErrorCodes.TOKEN_EXPIRED);
      }
      throw new AppError('Invalid access token', 401, ErrorCodes.INVALID_TOKEN);
    }
  }

  public static verifyRefreshToken(token: string): RefreshTokenPayload {
    try {
      return jwt.verify(token, env.JWT_REFRESH_SECRET) as RefreshTokenPayload;
    } catch (error) {
      if (error instanceof jwt.TokenExpiredError) {
        throw new AppError('Refresh token has expired', 401, ErrorCodes.REFRESH_TOKEN_EXPIRED);
      }
      throw new AppError('Invalid refresh token', 401, ErrorCodes.INVALID_TOKEN);
    }
  }

  public static hashToken(token: string): string {
    return crypto.createHash('sha256').update(token).digest('hex');
  }
}
