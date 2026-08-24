import { CardType, PersonaType } from '@prisma/client';
import { EnvironmentalContext } from './ContextAnalyzer.js';

export class PriorityEngine {
  public static calculatePriority(
    cardType: CardType,
    persona: PersonaType,
    context: EnvironmentalContext,
    userCustomWeights?: Record<string, number>,
  ): number {
    let score = this.getBasePersonaPriority(cardType, persona);

    // 1. Dynamic Environmental Triggers (USP Boosts)
    if (context.isSevereAqi) {
      if (cardType === CardType.AIR_QUALITY) score += 40;
      if (cardType === CardType.HEALTH_ADVISORY) score += 30;
      if (cardType === CardType.SEVERE_ALERTS) score += 50;
    }

    if (context.isRainImminent) {
      if (cardType === CardType.HOURLY_FORECAST) score += 25;
      if (cardType === CardType.RECOMMENDATIONS) score += 35;
      if (cardType === CardType.COMMUTE_ROUTING) score += 20;
    }

    if (context.isHighUv) {
      if (cardType === CardType.UV_INDEX) score += 30;
      if (cardType === CardType.RECOMMENDATIONS) score += 20;
    }

    if (context.isHighPollen && (persona === PersonaType.HEALTH_CONSCIOUS || persona === PersonaType.PARENT_FAMILY)) {
      if (cardType === CardType.POLLEN_REPORT) score += 35;
      if (cardType === CardType.HEALTH_ADVISORY) score += 25;
    }

    if (context.isFoggy) {
      if (cardType === CardType.COMMUTE_ROUTING) score += 40;
    }

    // 2. User Dynamic Adjustments
    if (userCustomWeights && userCustomWeights[cardType]) {
      score += userCustomWeights[cardType];
    }

    return score;
  }

  private static getBasePersonaPriority(card: CardType, persona: PersonaType): number {
    // Default base priority hierarchy per persona
    switch (persona) {
      case PersonaType.HEALTH_CONSCIOUS:
        switch (card) {
          case CardType.AIR_QUALITY:
            return 95;
          case CardType.POLLEN_REPORT:
            return 90;
          case CardType.HEALTH_ADVISORY:
            return 85;
          case CardType.CURRENT_WEATHER:
            return 80;
          case CardType.UV_INDEX:
            return 75;
          case CardType.HOURLY_FORECAST:
            return 70;
          default:
            return 40;
        }

      case PersonaType.OUTDOOR_FITNESS:
        switch (card) {
          case CardType.FITNESS_RUNNING_WINDOW:
            return 95;
          case CardType.CURRENT_WEATHER:
            return 90;
          case CardType.HOURLY_FORECAST:
            return 85;
          case CardType.AIR_QUALITY:
            return 80;
          case CardType.UV_INDEX:
            return 75;
          case CardType.RECOMMENDATIONS:
            return 70;
          default:
            return 40;
        }

      case PersonaType.AGRICULTURE_FARMER:
        switch (card) {
          case CardType.FARM_AGRICULTURE:
            return 95;
          case CardType.DAILY_FORECAST:
            return 90;
          case CardType.HOURLY_FORECAST:
            return 85;
          case CardType.RECOMMENDATIONS:
            return 80;
          case CardType.CURRENT_WEATHER:
            return 75;
          default:
            return 35;
        }

      case PersonaType.BEACH_SURFER:
        switch (card) {
          case CardType.MARINE_COASTAL:
            return 95;
          case CardType.CURRENT_WEATHER:
            return 90;
          case CardType.UV_INDEX:
            return 85;
          case CardType.HOURLY_FORECAST:
            return 80;
          default:
            return 35;
        }

      case PersonaType.TRAVELER:
        switch (card) {
          case CardType.TRAVEL_PLANNER:
            return 95;
          case CardType.DAILY_FORECAST:
            return 90;
          case CardType.CURRENT_WEATHER:
            return 85;
          case CardType.RECOMMENDATIONS:
            return 80;
          default:
            return 40;
        }

      case PersonaType.PARENT_FAMILY:
        switch (card) {
          case CardType.FAMILY_SCHOOL_ADVISORY:
            return 95;
          case CardType.CURRENT_WEATHER:
            return 90;
          case CardType.AIR_QUALITY:
            return 85;
          case CardType.HOURLY_FORECAST:
            return 80;
          default:
            return 40;
        }

      case PersonaType.COMMUTER:
        switch (card) {
          case CardType.COMMUTE_ROUTING:
            return 95;
          case CardType.HOURLY_FORECAST:
            return 90;
          case CardType.CURRENT_WEATHER:
            return 85;
          case CardType.AIR_QUALITY:
            return 80;
          default:
            return 40;
        }

      case PersonaType.EVENT_PLANNER:
        switch (card) {
          case CardType.OUTDOOR_EVENTS:
            return 95;
          case CardType.HOURLY_FORECAST:
            return 90;
          case CardType.DAILY_FORECAST:
            return 85;
          case CardType.CURRENT_WEATHER:
            return 80;
          default:
            return 40;
        }

      case PersonaType.GENERAL:
      default:
        switch (card) {
          case CardType.CURRENT_WEATHER:
            return 90;
          case CardType.HOURLY_FORECAST:
            return 85;
          case CardType.DAILY_FORECAST:
            return 80;
          case CardType.AIR_QUALITY:
            return 75;
          case CardType.RECOMMENDATIONS:
            return 70;
          case CardType.UV_INDEX:
            return 65;
          default:
            return 50;
        }
    }
  }
}
