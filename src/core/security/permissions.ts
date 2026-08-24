export const Permissions = {
  // Weather
  WEATHER_VIEW: 'weather:view',
  WEATHER_SYNC: 'weather:sync',
  WEATHER_OVERRIDE: 'weather:override',

  // Alerts
  ALERT_VIEW: 'alert:view',
  ALERT_CREATE: 'alert:create',
  ALERT_UPDATE: 'alert:update',
  ALERT_DELETE: 'alert:delete',

  // Personalization
  PERSONALIZATION_MANAGE: 'personalization:manage',
  RECOMMENDATION_MANAGE: 'recommendation:manage',

  // Users & Admin
  USER_VIEW: 'user:view',
  USER_MANAGE: 'user:manage',
  SYSTEM_SETTINGS: 'system:settings',
  ANALYTICS_VIEW: 'analytics:view',
} as const;

export type PermissionKey = (typeof Permissions)[keyof typeof Permissions];
