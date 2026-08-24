import { describe, it, expect } from 'vitest';
import { calculateHaversineDistance, isValidCoordinate } from '../../src/core/utils/geo.js';
import { getAqiCategory, getUvCategory, calculateHeatIndex } from '../../src/core/utils/calculations.js';

describe('Geo Utilities', () => {
  it('calculates accurate Haversine distance between Delhi and Mumbai (~1150km)', () => {
    const delhi = { latitude: 28.6139, longitude: 77.209 };
    const mumbai = { latitude: 18.922, longitude: 72.8347 };
    const dist = calculateHaversineDistance(delhi, mumbai);

    expect(dist).toBeGreaterThan(1100);
    expect(dist).toBeLessThan(1200);
  });

  it('validates coordinate boundaries accurately', () => {
    expect(isValidCoordinate(28.6139, 77.209)).toBe(true);
    expect(isValidCoordinate(95, 77.209)).toBe(false);
    expect(isValidCoordinate(28.6139, 190)).toBe(false);
  });
});

describe('Meteorological & Air Quality Calculations', () => {
  it('classifies Indian AQI categories accurately', () => {
    expect(getAqiCategory(45).category).toBe('GOOD');
    expect(getAqiCategory(80).category).toBe('SATISFACTORY');
    expect(getAqiCategory(150).category).toBe('MODERATE');
    expect(getAqiCategory(250).category).toBe('POOR');
    expect(getAqiCategory(350).category).toBe('VERY_POOR');
    expect(getAqiCategory(450).category).toBe('SEVERE');
  });

  it('classifies UV index categories accurately', () => {
    expect(getUvCategory(2).level).toBe('LOW');
    expect(getUvCategory(5).level).toBe('MODERATE');
    expect(getUvCategory(7).level).toBe('HIGH');
    expect(getUvCategory(9).level).toBe('VERY_HIGH');
    expect(getUvCategory(12).level).toBe('EXTREME');
  });

  it('calculates Heat Index when temperature is hot and humid', () => {
    const temp = 35; // 35C
    const humidity = 70; // 70%
    const heatIndex = calculateHeatIndex(temp, humidity);
    expect(heatIndex).toBeGreaterThan(temp);
  });
});
