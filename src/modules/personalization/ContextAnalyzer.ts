import { NormalizedWeatherReport } from '@integrations/weather/weather.types.js';
import { NormalizedEnvironmentReport } from '@integrations/aqi/aqi.types.js';

export interface EnvironmentalContext {
  isSevereAqi: boolean;
  isHighUv: boolean;
  isRainImminent: boolean;
  isExtremeTemperature: boolean;
  isHighPollen: boolean;
  isFoggy: boolean;
}

export class ContextAnalyzer {
  public static analyze(
    weather: NormalizedWeatherReport,
    env: NormalizedEnvironmentReport,
  ): EnvironmentalContext {
    const isSevereAqi = env.aqi.aqi > 200;
    const isHighUv = env.uv.uvIndex >= 8;
    const isRainImminent =
      weather.current.precipitation > 0 ||
      weather.current.condition === 'RAIN' ||
      weather.current.condition === 'HEAVY_RAIN' ||
      weather.current.condition === 'THUNDERSTORM' ||
      weather.hourly.slice(0, 3).some((h) => h.precipitationProb >= 50);

    const isExtremeTemperature =
      weather.current.temperature >= 38 || weather.current.temperature <= 6;
    const isHighPollen = env.pollen.overallCategory === 'HIGH' || env.pollen.overallCategory === 'VERY_HIGH';
    const isFoggy = env.visibility.fogRisk || env.visibility.visibilityKm < 2.0;

    return {
      isSevereAqi,
      isHighUv,
      isRainImminent,
      isExtremeTemperature,
      isHighPollen,
      isFoggy,
    };
  }
}
