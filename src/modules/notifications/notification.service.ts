import { prisma } from '@config/database.js';
import { notificationQueue } from '@queues/queue.manager.js';
import { NotificationType } from '@prisma/client';
import { logger } from '@config/logger.js';

export interface SendPushInput {
  userId: string;
  title: string;
  body: string;
  type?: NotificationType;
  dataPayload?: Record<string, unknown>;
}

export class NotificationService {
  public static async getUserNotifications(userId: string) {
    return prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
  }

  public static async markAsRead(userId: string, notificationId: string) {
    return prisma.notification.updateMany({
      where: { id: notificationId, userId },
      data: { isRead: true, readAt: new Date() },
    });
  }

  public static async markAllAsRead(userId: string) {
    return prisma.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true, readAt: new Date() },
    });
  }

  public static async sendNotification(input: SendPushInput) {
    // 1. Create DB notification record
    const notification = await prisma.notification.create({
      data: {
        userId: input.userId,
        title: input.title,
        body: input.body,
        type: input.type || NotificationType.WEATHER_ALERT,
        dataPayload: input.dataPayload ? JSON.parse(JSON.stringify(input.dataPayload)) : undefined,
      },
    });

    // 2. Queue push notification for background delivery via BullMQ
    try {
      await notificationQueue.add('send-push', {
        notificationId: notification.id,
        userId: input.userId,
        title: input.title,
        body: input.body,
        data: input.dataPayload,
      });
    } catch (err) {
      logger.warn({ err }, 'Failed to enqueue notification, stored in DB only');
    }

    return notification;
  }

  public static async registerDeviceToken(userId: string, token: string, platform = 'android') {
    return prisma.deviceToken.upsert({
      where: { token },
      update: {
        userId,
        platform,
        isActive: true,
        lastSeenAt: new Date(),
      },
      create: {
        userId,
        token,
        platform,
      },
    });
  }
}
