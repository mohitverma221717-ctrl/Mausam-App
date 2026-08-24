import { prisma } from '@config/database.js';
import { UserRoleType, PersonaType } from '@prisma/client';

export class AuthRepository {
  public static async findByEmail(email: string) {
    return prisma.user.findUnique({
      where: { email },
      include: {
        roles: { include: { role: true } },
        profile: true,
        preferences: true,
      },
    });
  }

  public static async findById(id: string) {
    return prisma.user.findUnique({
      where: { id },
      include: {
        roles: { include: { role: true } },
        profile: true,
        preferences: true,
      },
    });
  }

  public static async createUser(data: {
    email: string;
    passwordHash: string;
    phoneNumber?: string;
    fullName?: string;
    persona?: PersonaType;
  }) {
    const defaultRole = await prisma.role.findUnique({
      where: { name: UserRoleType.USER },
    });

    return prisma.user.create({
      data: {
        email: data.email,
        passwordHash: data.passwordHash,
        phoneNumber: data.phoneNumber,
        roles: defaultRole
          ? {
              create: {
                roleId: defaultRole.id,
              },
            }
          : undefined,
        profile: {
          create: {
            fullName: data.fullName,
            persona: data.persona || PersonaType.GENERAL,
          },
        },
        preferences: {
          create: {},
        },
        personalizationProfile: {
          create: {
            personaType: data.persona || PersonaType.GENERAL,
          },
        },
      },
      include: {
        roles: { include: { role: true } },
        profile: true,
        preferences: true,
      },
    });
  }

  public static async createRefreshToken(data: {
    tokenHash: string;
    userId: string;
    familyId: string;
    expiresAt: Date;
  }) {
    return prisma.refreshToken.create({
      data,
    });
  }

  public static async findRefreshToken(tokenHash: string) {
    return prisma.refreshToken.findUnique({
      where: { tokenHash },
    });
  }

  public static async revokeRefreshTokenFamily(familyId: string) {
    return prisma.refreshToken.updateMany({
      where: { familyId },
      data: { isRevoked: true },
    });
  }

  public static async revokeRefreshToken(id: string) {
    return prisma.refreshToken.update({
      where: { id },
      data: { isRevoked: true },
    });
  }

  public static async updatePassword(userId: string, passwordHash: string) {
    return prisma.user.update({
      where: { id: userId },
      data: { passwordHash },
    });
  }

  public static async recordLoginSession(data: {
    userId: string;
    ipAddress?: string;
    userAgent?: string;
    deviceType?: string;
  }) {
    return prisma.loginSession.create({
      data,
    });
  }

  public static async registerDeviceToken(data: {
    userId: string;
    token: string;
    platform: string;
  }) {
    return prisma.deviceToken.upsert({
      where: { token: data.token },
      update: {
        userId: data.userId,
        platform: data.platform,
        isActive: true,
        lastSeenAt: new Date(),
      },
      create: {
        userId: data.userId,
        token: data.token,
        platform: data.platform,
      },
    });
  }
}
