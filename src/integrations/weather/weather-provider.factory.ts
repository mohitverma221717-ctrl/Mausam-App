import { IWeatherProvider } from './IWeatherProvider.js';
import { OpenMeteoWeatherProvider } from './open-meteo.provider.js';
import { MockWeatherProvider } from './mock.provider.js';
import { env } from '@config/env.js';

export class WeatherProviderFactory {
  private static primaryProvider: IWeatherProvider = new OpenMeteoWeatherProvider();
  private static fallbackProvider: IWeatherProvider = new MockWeatherProvider();

  public static getProvider(): IWeatherProvider {
    if (env.NODE_ENV === 'test') {
      return this.fallbackProvider;
    }
    return this.primaryProvider;
  }

  public static getFallbackProvider(): IWeatherProvider {
    return this.fallbackProvider;
  }
}
