import { CardType, PersonaType } from '@prisma/client';

export interface HomepageCardItem {
  id: string;
  type: CardType;
  priority: number;
  title: string;
  subtitle?: string;
  data: Record<string, unknown>;
  badge?: {
    text: string;
    type: 'critical' | 'warning' | 'info' | 'success';
  };
}

export interface PersonalizedHomepageResponse {
  location: {
    id: string;
    name: string;
    state?: string | null;
    country: string;
    latitude: number;
    longitude: number;
  };
  persona: PersonaType;
  weatherSummary: {
    temperature: number;
    feelsLike: number;
    condition: string;
    iconCode: string;
    tempUnit: string;
  };
  environmentalSummary: {
    aqi: number;
    aqiCategory: string;
    uvIndex: number;
    uvCategory: string;
  };
  activeAlertsCount: number;
  cards: HomepageCardItem[];
  recommendations: Array<{
    id: string;
    type: string;
    severity: string;
    title: string;
    description: string;
    reason: string;
  }>;
}
