import dotenv from 'dotenv';
import path from 'path';
import { z } from 'zod';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.string().transform((val) => parseInt(val, 10)).default('5000'),
  API_PREFIX: z.string().default('/api/v1'),
  CORS_ORIGIN: z.string().default('*'),
  LOG_LEVEL: z.enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace']).default('info'),

  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),
  DIRECT_URL: z.string().optional(),

  REDIS_HOST: z.string().default('localhost'),
  REDIS_PORT: z.string().transform((val) => parseInt(val, 10)).default('6379'),
  REDIS_PASSWORD: z.string().optional().default(''),
  REDIS_URL: z.string().optional(),

  JWT_SECRET: z.string().min(16, 'JWT_SECRET must be at least 16 chars'),
  JWT_REFRESH_SECRET: z.string().min(16, 'JWT_REFRESH_SECRET must be at least 16 chars'),
  JWT_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('7d'),

  RATE_LIMIT_WINDOW_MS: z.string().transform((val) => parseInt(val, 10)).default('900000'),
  RATE_LIMIT_MAX: z.string().transform((val) => parseInt(val, 10)).default('1000'),

  FIREBASE_PROJECT_ID: z.string().optional(),
  FIREBASE_CLIENT_EMAIL: z.string().optional(),
  FIREBASE_PRIVATE_KEY: z.string().optional(),

  IMD_API_BASE_URL: z.string().default('https://mausam.imd.gov.in/api'),
  IMD_API_KEY: z.string().optional().default('mock_imd_api_key'),
  OPEN_METEO_BASE_URL: z.string().default('https://api.open-meteo.com/v1'),
  OPEN_METEO_AIR_QUALITY_URL: z.string().default('https://air-quality-api.open-meteo.com/v1'),
  WEATHER_API_KEY: z.string().optional().default('demo_weather_api_key'),
  AQI_API_KEY: z.string().optional().default('demo_aqi_api_key'),
  MAPS_API_KEY: z.string().optional().default('demo_maps_api_key'),
  MARINE_API_KEY: z.string().optional().default('demo_marine_api_key'),
});

const _env = envSchema.safeParse(process.env);

if (!_env.success) {
  console.error('❌ Invalid environment variables:', _env.error.format());
  throw new Error('Invalid environment variables');
}

export const env = _env.data;
export type Env = typeof env;
