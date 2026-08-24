/**
 * Calculates Heat Index (apparent temperature) in Celsius
 */
export function calculateHeatIndex(tempCelsius: number, humidityPercent: number): number {
  if (tempCelsius < 27 || humidityPercent < 40) {
    return tempCelsius;
  }

  // Convert Celsius to Fahrenheit
  const T = (tempCelsius * 9) / 5 + 32;
  const R = humidityPercent;

  const c1 = -42.379;
  const c2 = 2.04901523;
  const c3 = 10.14333127;
  const c4 = -0.22475541;
  const c5 = -0.00683783;
  const c6 = -0.05481717;
  const c7 = 0.00122874;
  const c8 = 0.00085282;
  const c9 = -0.00000199;

  let hi =
    c1 +
    c2 * T +
    c3 * R +
    c4 * T * R +
    c5 * T * T +
    c6 * R * R +
    c7 * T * T * R +
    c8 * T * R * R +
    c9 * T * T * R * R;

  // Convert back to Celsius
  return Math.round((((hi - 32) * 5) / 9) * 10) / 10;
}

/**
 * Calculates Wind Chill in Celsius
 */
export function calculateWindChill(tempCelsius: number, windSpeedKmh: number): number {
  if (tempCelsius > 10 || windSpeedKmh <= 4.8) {
    return tempCelsius;
  }
  const vPow = Math.pow(windSpeedKmh, 0.16);
  const wc = 13.12 + 0.6215 * tempCelsius - 11.37 * vPow + 0.3965 * tempCelsius * vPow;
  return Math.round(wc * 10) / 10;
}

/**
 * Maps standard Indian AQI value to category and color code
 */
export function getAqiCategory(aqi: number): {
  category: 'GOOD' | 'SATISFACTORY' | 'MODERATE' | 'POOR' | 'VERY_POOR' | 'SEVERE';
  color: string;
  advisory: string;
} {
  if (aqi <= 50) {
    return {
      category: 'GOOD',
      color: '#00B050',
      advisory: 'Air quality is considered satisfactory, and air pollution poses little or no risk.',
    };
  }
  if (aqi <= 100) {
    return {
      category: 'SATISFACTORY',
      color: '#92D050',
      advisory: 'Minor breathing discomfort to sensitive people.',
    };
  }
  if (aqi <= 200) {
    return {
      category: 'MODERATE',
      color: '#FFFF00',
      advisory: 'Breathing discomfort to the people with lungs, asthma and heart diseases.',
    };
  }
  if (aqi <= 300) {
    return {
      category: 'POOR',
      color: '#FF9900',
      advisory: 'Breathing discomfort to most people on prolonged exposure.',
    };
  }
  if (aqi <= 400) {
    return {
      category: 'VERY_POOR',
      color: '#FF0000',
      advisory: 'Respiratory illness on prolonged exposure.',
    };
  }
  return {
    category: 'SEVERE',
    color: '#C00000',
    advisory: 'Affects healthy people and seriously impacts those with existing diseases.',
  };
}

/**
 * Maps UV index to risk level and advisory
 */
export function getUvCategory(uvIndex: number): {
  level: 'LOW' | 'MODERATE' | 'HIGH' | 'VERY_HIGH' | 'EXTREME';
  color: string;
  advisory: string;
} {
  if (uvIndex < 3) {
    return {
      level: 'LOW',
      color: '#558B2F',
      advisory: 'Low danger for the average person. Wear sunglasses on bright days.',
    };
  }
  if (uvIndex < 6) {
    return {
      level: 'MODERATE',
      color: '#F9A825',
      advisory: 'Moderate risk of harm from unprotected sun exposure. Stay in shade during midday.',
    };
  }
  if (uvIndex < 8) {
    return {
      level: 'HIGH',
      color: '#EF6C00',
      advisory: 'High risk of harm. Protection against sun damage is needed. Wear SPF 30+.',
    };
  }
  if (uvIndex < 11) {
    return {
      level: 'VERY_HIGH',
      color: '#C62828',
      advisory: 'Very high risk of harm. Take extra precautions. Unprotected skin will be damaged.',
    };
  }
  return {
    level: 'EXTREME',
    color: '#6A1B9A',
    advisory: 'Extreme risk of harm. Avoid outdoor exposure between 10 a.m. and 4 p.m.',
  };
}
