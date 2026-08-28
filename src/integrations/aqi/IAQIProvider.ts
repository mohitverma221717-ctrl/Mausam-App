import { NormalizedEnvironmentReport, NormalizedAQIData } from './aqi.types.js';

export interface IAQIProvider {
  readonly providerName: string;

  getAQI(lat: number, lon: number): Promise<NormalizedAQIData>;

  getFullEnvironmentReport(lat: number, lon: number): Promise<NormalizedEnvironmentReport>;
}
