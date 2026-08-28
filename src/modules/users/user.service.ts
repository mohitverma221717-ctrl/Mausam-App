import { prisma } from '@config/database.js';
import { AppError } from '@core/errors/AppError.js';
import { ErrorCodes } from '@core/errors/ErrorCodes.js';
import { UpdateProfileInput, UpdatePreferencesInput, AddInterestInput } from './user.schema.js';

export class UserService {
  public static async getProfile(userId: string) {
    const profile = await prisma.userProfile.findUnique({
      where: { userId },
    });
    if (!profile) {
      throw new AppError('Profile not found', 404, ErrorCodes.NOT_FOUND);
    }
    return profile;
  }

  public static async updateProfile(userId: string, input: UpdateProfileInput) {
    const updated = await prisma.userProfile.upsert({
      where: { userId },
      update: {
        ...input,
        dateOfBirth: input.dateOfBirth ? new Date(input.dateOfBirth) : undefined,
      },
      create: {
        userId,
        ...input,
        dateOfBirth: input.dateOfBirth ? new Date(input.dateOfBirth) : undefined,
      },
    });

    if (input.persona) {
      await prisma.personalizationProfile.upsert({
        where: { userId },
        update: { personaType: input.persona },
        create: { userId, personaType: input.persona },
      });
    }

    return updated;
  }

  public static async getPreferences(userId: string) {
    return prisma.userPreference.findUnique({
      where: { userId },
    });
  }

  public static async updatePreferences(userId: string, input: UpdatePreferencesInput) {
    return prisma.userPreference.upsert({
      where: { userId },
      update: input,
      create: {
        userId,
        ...input,
      },
    });
  }

  public static async getInterests(userId: string) {
    return prisma.userInterest.findMany({
      where: { userId },
      orderBy: { priority: 'desc' },
    });
  }

  public static async addInterest(userId: string, input: AddInterestInput) {
    return prisma.userInterest.upsert({
      where: {
        userId_interest: {
          userId,
          interest: input.interest.toLowerCase(),
        },
      },
      update: { priority: input.priority },
      create: {
        userId,
        interest: input.interest.toLowerCase(),
        priority: input.priority,
      },
    });
  }

  public static async removeInterest(userId: string, interest: string) {
    await prisma.userInterest.deleteMany({
      where: {
        userId,
        interest: interest.toLowerCase(),
      },
    });
    return { message: 'Interest removed successfully' };
  }
}
