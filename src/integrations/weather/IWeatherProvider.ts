import { NormalizedWeatherReport, NormalizedCurrentWeather } from './weather.types.js';

export interface IWeatherProvider {
  readonly providerName: string;

  getCurrentWeather(latitude: number, longitude: number): Promise<NormalizedCurrentWeather>;

  getFullWeatherForecast(latitude: number, longitude: number): Promise<NormalizedWeatherReport>;
}
