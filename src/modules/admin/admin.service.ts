import { prisma } from '@config/database.js';
import { CardType, PersonaType } from '@prisma/client';
import { parsePagination, formatPaginatedResult } from '@core/utils/pagination.js';

export class AdminService {
  public static async getDashboardStats() {
    const [
      totalUsers,
      activeAlertsCount,
      totalLocations,
      totalObservations,
      recentAuditLogs,
      dataSources,
    ] = await Promise.all([
      prisma.user.count(),
      prisma.alert.count({ where: { expiresAt: { gte: new Date() } } }),
      prisma.location.count(),
      prisma.weatherObservation.count(),
      prisma.auditLog.findMany({ take: 10, orderBy: { createdAt: 'desc' } }),
      prisma.dataSourceStatus.findMany(),
    ]);

    return {
      metrics: {
        totalUsers,
        activeAlertsCount,
        totalLocations,
        totalObservations,
      },
      dataSources,
      recentAuditLogs,
    };
  }

  public static async getUsers(query: { page?: unknown; limit?: unknown }) {
    const pagination = parsePagination(query);
    const [items, total] = await Promise.all([
      prisma.user.findMany({
        skip: pagination.skip,
        take: pagination.limit,
        orderBy: { createdAt: 'desc' },
        include: {
          profile: true,
          roles: { include: { role: true } },
        },
      }),
      prisma.user.count(),
    ]);

    return formatPaginatedResult(items, total, pagination);
  }

  public static async getPersonalizationRules() {
    const [rules, cards, cardPriorities] = await Promise.all([
      prisma.personalizationRule.findMany({ orderBy: { priorityScore: 'desc' } }),
      prisma.homepageCard.findMany({ orderBy: { defaultPriority: 'desc' } }),
      prisma.cardPriority.findMany({ orderBy: { basePriority: 'desc' } }),
    ]);

    return {
      rules,
      cards,
      cardPriorities,
    };
  }

  public static async updateCardPriority(
    adminId: string,
    personaType: PersonaType,
    cardType: CardType,
    basePriority: number,
    weightMultiplier: number,
  ) {
    const updated = await prisma.cardPriority.upsert({
      where: { personaType_cardType: { personaType, cardType } },
      update: { basePriority, weightMultiplier },
      create: { personaType, cardType, basePriority, weightMultiplier },
    });

    // Record audit log
    await prisma.auditLog.create({
      data: {
        userId: adminId,
        action: 'UPDATE_CARD_PRIORITY',
        entity: 'CardPriority',
        entityId: `${personaType}_${cardType}`,
        payload: { personaType, cardType, basePriority, weightMultiplier },
      },
    });

    return updated;
  }

  public static async getSystemSettings() {
    return prisma.systemSetting.findMany();
  }

  public static async updateSystemSetting(adminId: string, key: string, value: string) {
    const updated = await prisma.systemSetting.update({
      where: { key },
      data: { value },
    });

    await prisma.auditLog.create({
      data: {
        userId: adminId,
        action: 'UPDATE_SYSTEM_SETTING',
        entity: 'SystemSetting',
        entityId: key,
        payload: { key, value },
      },
    });

    return updated;
  }
}
