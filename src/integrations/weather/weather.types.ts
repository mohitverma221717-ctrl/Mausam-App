import { WeatherCondition } from '@prisma/client';

export interface NormalizedCurrentWeather {
  temperature: number;
  feelsLike: number;
  minTemp?: number;
  maxTemp?: number;
  humidity: number;
  pressure: number;
  windSpeed: number;
  windDirection: number;
  windGust?: number;
  precipitation: number;
  precipitationProb: number;
  cloudCover: number;
  uvIndex: number;
  visibility: number;
  condition: WeatherCondition;
  conditionCode: number;
  iconCode: string;
  observationTime: Date;
  dataSource: string;
  isMock: boolean;
}

export interface NormalizedHourlyForecast {
  time: Date;
  temperature: number;
  feelsLike: number;
  humidity: number;
  precipitationProb: number;
  precipitation: number;
  windSpeed: number;
  windDirection: number;
  condition: WeatherCondition;
  iconCode: string;
  uvIndex: number;
}

export interface NormalizedDailyForecast {
  date: Date;
  minTemp: number;
  maxTemp: number;
  condition: WeatherCondition;
  precipitationProb: number;
  precipitationSum: number;
  sunrise?: Date;
  sunset?: Date;
  uvMax: number;
  windMax: number;
}

export interface NormalizedWeatherReport {
  current: NormalizedCurrentWeather;
  hourly: NormalizedHourlyForecast[];
  daily: NormalizedDailyForecast[];
}
