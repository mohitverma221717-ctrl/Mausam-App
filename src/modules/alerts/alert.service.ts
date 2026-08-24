import { prisma } from '@config/database.js';
import { AlertSeverity, AlertCategory } from '@prisma/client';
import { calculateHaversineDistance } from '@core/utils/geo.js';

export interface CreateAlertInput {
  title: string;
  description: string;
  severity: AlertSeverity;
  category: AlertCategory;
  eventType: string;
  effectiveFrom: Date;
  expiresAt: Date;
  sender?: string;
  areaDescription?: string;
  latitude?: number;
  longitude?: number;
  radiusKm?: number;
  locationId?: string;
}

export class AlertService {
  public static async getActiveAlerts(lat?: number, lon?: number) {
    const alerts = await prisma.alert.findMany({
      where: {
        isApproved: true,
        expiresAt: { gte: new Date() },
      },
      orderBy: { createdAt: 'desc' },
      include: { location: true },
    });

    if (lat === undefined || lon === undefined) {
      return alerts;
    }

    // Filter by spatial radius if coordinates are provided
    return alerts.filter((alert) => {
      if (alert.latitude && alert.longitude && alert.radiusKm) {
        const dist = calculateHaversineDistance(
          { latitude: lat, longitude: lon },
          { latitude: alert.latitude, longitude: alert.longitude },
        );
        return dist <= alert.radiusKm;
      }
      return true; // Broadcast alerts without geo limits match all
    });
  }

  public static async getAlertById(id: string) {
    return prisma.alert.findUnique({
      where: { id },
      include: { location: true, targets: true },
    });
  }

  public static async createAlert(input: CreateAlertInput) {
    return prisma.alert.create({
      data: {
        title: input.title,
        description: input.description,
        severity: input.severity,
        category: input.category,
        eventType: input.eventType,
        effectiveFrom: new Date(input.effectiveFrom),
        expiresAt: new Date(input.expiresAt),
        sender: input.sender || 'IMD_CENTRAL_OFFICE',
        areaDescription: input.areaDescription,
        latitude: input.latitude,
        longitude: input.longitude,
        radiusKm: input.radiusKm,
        locationId: input.locationId,
        isApproved: true,
      },
    });
  }

  public static async evaluateWeatherAlertRules(
    temperature: number,
    rainfall24h: number,
    windSpeed: number,
    aqi: number,
  ) {
    const triggered: { title: string; severity: AlertSeverity; desc: string }[] = [];

    if (temperature >= 44.0) {
      triggered.push({
        title: 'Severe Heatwave Warning',
        severity: AlertSeverity.WARNING,
        desc: `Extreme high temperatures (${temperature}°C) exceeding safety thresholds. Avoid sun exposure.`,
      });
    }

    if (rainfall24h >= 64.5) {
      triggered.push({
        title: 'Heavy Rainfall Warning',
        severity: AlertSeverity.WARNING,
        desc: `Heavy precipitation accumulation (${rainfall24h} mm) expected. Waterlogging risk.`,
      });
    }

    if (windSpeed >= 50.0) {
      triggered.push({
        title: 'High Wind / Squall Advisory',
        severity: AlertSeverity.ADVISORY,
        desc: `Strong gusty winds (${windSpeed} km/h). Secure loose outdoor structures.`,
      });
    }

    if (aqi >= 401) {
      triggered.push({
        title: 'Emergency Air Quality Alert',
        severity: AlertSeverity.EMERGENCY,
        desc: `Severe AQI (${aqi}) posing health emergency for entire population. Stay indoors.`,
      });
    }

    return triggered;
  }
}
