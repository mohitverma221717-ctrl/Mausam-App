import { AQICategory, PollenLevel, UVCategory } from '@prisma/client';

export interface NormalizedAQIData {
  aqi: number;
  category: AQICategory;
  pm25: number;
  pm10: number;
  o3?: number;
  no2?: number;
  so2?: number;
  co?: number;
  dominantPollutant: string;
  healthAdvisory: string;
  observationTime: Date;
  dataSource: string;
  isMock: boolean;
}

export interface NormalizedPollenData {
  grassPollen: number;
  treePollen: number;
  weedPollen: number;
  olivePollen: number;
  overallCategory: PollenLevel;
  advisory: string;
  observationTime: Date;
  dataSource: string;
  isMock: boolean;
}

export interface NormalizedUVData {
  uvIndex: number;
  maxUvIndex: number;
  category: UVCategory;
  exposureAdvisory: string;
  observationTime: Date;
  dataSource: string;
}

export interface NormalizedVisibilityData {
  visibilityKm: number;
  category: string;
  fogRisk: boolean;
  observationTime: Date;
  dataSource: string;
}

export interface NormalizedEnvironmentReport {
  aqi: NormalizedAQIData;
  pollen: NormalizedPollenData;
  uv: NormalizedUVData;
  visibility: NormalizedVisibilityData;
}
