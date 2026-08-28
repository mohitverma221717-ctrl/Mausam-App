import { v4 as uuidv4 } from 'uuid';
import { AuthRepository } from './auth.repository.js';
import { PasswordUtil } from '@core/security/password.js';
import { JwtUtil } from '@core/security/jwt.js';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';
import { addDays } from '@core/utils/date-time.js';
import { RegisterInput, LoginInput, ChangePasswordInput } from './auth.schema.js';

export class AuthService {
  public static async register(input: RegisterInput) {
    const existing = await AuthRepository.findByEmail(input.email);
    if (existing) {
      throw new AppError('User with this email already exists', 409, ErrorCodes.USER_ALREADY_EXISTS);
    }

    const passwordHash = await PasswordUtil.hash(input.password);
    const user = await AuthRepository.createUser({
      email: input.email,
      passwordHash,
      phoneNumber: input.phoneNumber,
      fullName: input.fullName,
      persona: input.persona,
    });

    const roles = user.roles.map((r) => r.role.name);
    const accessToken = JwtUtil.generateAccessToken({
      userId: user.id,
      email: user.email,
      roles,
    });

    const familyId = uuidv4();
    const refreshTokenId = uuidv4();
    const refreshToken = JwtUtil.generateRefreshToken({
      userId: user.id,
      familyId,
      tokenId: refreshTokenId,
    });

    await AuthRepository.createRefreshToken({
      tokenHash: JwtUtil.hashToken(refreshToken),
      userId: user.id,
      familyId,
      expiresAt: addDays(new Date(), 7),
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        isVerified: user.isVerified,
        roles,
        profile: user.profile,
        preferences: user.preferences,
      },
      tokens: {
        accessToken,
        refreshToken,
      },
    };
  }

  public static async login(
    input: LoginInput,
    metadata?: { ipAddress?: string; userAgent?: string },
  ) {
    const user = await AuthRepository.findByEmail(input.email);
    if (!user) {
      throw new AppError('Invalid email or password', 401, ErrorCodes.INVALID_CREDENTIALS);
    }

    const isMatch = await PasswordUtil.compare(input.password, user.passwordHash);
    if (!isMatch) {
      throw new AppError('Invalid email or password', 401, ErrorCodes.INVALID_CREDENTIALS);
    }

    const roles = user.roles.map((r) => r.role.name);
    const accessToken = JwtUtil.generateAccessToken({
      userId: user.id,
      email: user.email,
      roles,
    });

    const familyId = uuidv4();
    const refreshTokenId = uuidv4();
    const refreshToken = JwtUtil.generateRefreshToken({
      userId: user.id,
      familyId,
      tokenId: refreshTokenId,
    });

    await Promise.all([
      AuthRepository.createRefreshToken({
        tokenHash: JwtUtil.hashToken(refreshToken),
        userId: user.id,
        familyId,
        expiresAt: addDays(new Date(), 7),
      }),
      AuthRepository.recordLoginSession({
        userId: user.id,
        ipAddress: metadata?.ipAddress,
        userAgent: metadata?.userAgent,
        deviceType: input.platform,
      }),
      input.deviceToken
        ? AuthRepository.registerDeviceToken({
            userId: user.id,
            token: input.deviceToken,
            platform: input.platform,
          })
        : Promise.resolve(),
    ]);

    return {
      user: {
        id: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        isVerified: user.isVerified,
        roles,
        profile: user.profile,
        preferences: user.preferences,
      },
      tokens: {
        accessToken,
        refreshToken,
      },
    };
  }

  public static async refreshToken(token: string) {
    const payload = JwtUtil.verifyRefreshToken(token);
    const tokenHash = JwtUtil.hashToken(token);

    const savedToken = await AuthRepository.findRefreshToken(tokenHash);
    if (!savedToken) {
      throw new AppError('Invalid refresh token', 401, ErrorCodes.INVALID_TOKEN);
    }

    // Refresh token reuse detection (Security alert!)
    if (savedToken.isRevoked) {
      await AuthRepository.revokeRefreshTokenFamily(savedToken.familyId);
      throw new AppError(
        'Compromised refresh token reused. All active sessions invalidated.',
        401,
        ErrorCodes.REFRESH_TOKEN_REUSED,
      );
    }

    // Revoke old refresh token (Rotate)
    await AuthRepository.revokeRefreshToken(savedToken.id);

    const user = await AuthRepository.findById(payload.userId);
    if (!user) {
      throw new AppError('User not found', 404, ErrorCodes.USER_NOT_FOUND);
    }

    const roles = user.roles.map((r) => r.role.name);
    const newAccessToken = JwtUtil.generateAccessToken({
      userId: user.id,
      email: user.email,
      roles,
    });

    const newRefreshToken = JwtUtil.generateRefreshToken({
      userId: user.id,
      familyId: savedToken.familyId,
      tokenId: uuidv4(),
    });

    await AuthRepository.createRefreshToken({
      tokenHash: JwtUtil.hashToken(newRefreshToken),
      userId: user.id,
      familyId: savedToken.familyId,
      expiresAt: addDays(new Date(), 7),
    });

    return {
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    };
  }

  public static async logout(refreshToken?: string) {
    if (refreshToken) {
      const tokenHash = JwtUtil.hashToken(refreshToken);
      const savedToken = await AuthRepository.findRefreshToken(tokenHash);
      if (savedToken) {
        await AuthRepository.revokeRefreshToken(savedToken.id);
      }
    }
    return { message: 'Logged out successfully' };
  }

  public static async getCurrentUser(userId: string) {
    const user = await AuthRepository.findById(userId);
    if (!user) {
      throw new AppError('User not found', 404, ErrorCodes.USER_NOT_FOUND);
    }
    return {
      id: user.id,
      email: user.email,
      phoneNumber: user.phoneNumber,
      isVerified: user.isVerified,
      roles: user.roles.map((r) => r.role.name),
      profile: user.profile,
      preferences: user.preferences,
      createdAt: user.createdAt,
    };
  }

  public static async changePassword(userId: string, input: ChangePasswordInput) {
    const user = await AuthRepository.findById(userId);
    if (!user) {
      throw new AppError('User not found', 404, ErrorCodes.USER_NOT_FOUND);
    }

    const isMatch = await PasswordUtil.compare(input.currentPassword, user.passwordHash);
    if (!isMatch) {
      throw new AppError('Incorrect current password', 400, ErrorCodes.BAD_REQUEST);
    }

    const newPasswordHash = await PasswordUtil.hash(input.newPassword);
    await AuthRepository.updatePassword(userId, newPasswordHash);

    return { message: 'Password changed successfully' };
  }
}
