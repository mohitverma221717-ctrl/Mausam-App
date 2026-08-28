import { prisma } from '@config/database.js';

export interface RecordEventInput {
  userId?: string;
  eventName: string;
  category: string;
  platform: string;
  appVersion?: string;
  metadata?: Record<string, unknown>;
  ipAddress?: string;
  userAgent?: string;
}

export class AnalyticsService {
  public static async recordEvent(input: RecordEventInput) {
    return prisma.analyticsEvent.create({
      data: {
        userId: input.userId,
        eventName: input.eventName,
        category: input.category,
        platform: input.platform,
        appVersion: input.appVersion,
        metadata: input.metadata ? JSON.parse(JSON.stringify(input.metadata)) : undefined,
        ipAddress: input.ipAddress,
        userAgent: input.userAgent,
      },
    });
  }

  public static async getSummary() {
    const [totalEvents, eventBreakdown] = await Promise.all([
      prisma.analyticsEvent.count(),
      prisma.analyticsEvent.groupBy({
        by: ['eventName'],
        _count: { id: true },
        orderBy: { _count: { id: 'desc' } },
        take: 10,
      }),
    ]);

    return {
      totalEvents,
      topEvents: eventBreakdown.map((e) => ({
        eventName: e.eventName,
        count: e._count.id,
      })),
    };
  }
}
