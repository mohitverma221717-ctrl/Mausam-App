import { z } from 'zod';
import { PersonaType } from '@prisma/client';

export const updateProfileSchema = z.object({
  fullName: z.string().min(2).optional(),
  avatarUrl: z.string().url().optional(),
  bio: z.string().max(300).optional(),
  dateOfBirth: z.string().datetime().optional(),
  gender: z.enum(['MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY']).optional(),
  persona: z.nativeEnum(PersonaType).optional(),
});

export const updatePreferencesSchema = z.object({
  tempUnit: z.enum(['C', 'F']).optional(),
  windSpeedUnit: z.enum(['km/h', 'm/s', 'mph']).optional(),
  pressureUnit: z.enum(['hPa', 'mmHg', 'inHg']).optional(),
  theme: z.enum(['light', 'dark', 'system']).optional(),
  language: z.string().optional(),
  notifyWeatherAlerts: z.boolean().optional(),
  notifyDailySummary: z.boolean().optional(),
  notifyAqiWarnings: z.boolean().optional(),
});

export const addInterestSchema = z.object({
  interest: z.string().min(1),
  priority: z.number().int().min(1).max(10).default(5),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
export type UpdatePreferencesInput = z.infer<typeof updatePreferencesSchema>;
export type AddInterestInput = z.infer<typeof addInterestSchema>;
