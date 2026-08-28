import { z } from 'zod';

export const searchLocationSchema = z.object({
  query: z.string().min(1, 'Search query is required'),
});

export const nearbyLocationSchema = z.object({
  latitude: z.string().transform((v) => parseFloat(v)),
  longitude: z.string().transform((v) => parseFloat(v)),
  radiusKm: z.string().transform((v) => parseFloat(v)).default('50'),
});

export const saveLocationSchema = z.object({
  locationId: z.string().uuid(),
  customName: z.string().optional(),
  isHome: z.boolean().default(false),
  isWork: z.boolean().default(false),
});

export const favoriteLocationSchema = z.object({
  locationId: z.string().uuid(),
  orderIndex: z.number().int().default(0),
});

export type SearchLocationInput = z.infer<typeof searchLocationSchema>;
export type NearbyLocationInput = z.infer<typeof nearbyLocationSchema>;
export type SaveLocationInput = z.infer<typeof saveLocationSchema>;
export type FavoriteLocationInput = z.infer<typeof favoriteLocationSchema>;
