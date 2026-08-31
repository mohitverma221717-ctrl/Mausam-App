import 'package:flutter/material.dart';
import '../../../weather/domain/models/weather_data.dart';
import '../../disaster/domain/models/disaster_model.dart';

class PersonalizedCard {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final int priority;
  final String actionRoute;

  const PersonalizedCard({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.priority,
    required this.actionRoute,
  });
}

class PersonalizationEngine {
  static List<PersonalizedCard> generateCards({
    required WeatherData weather,
    required List<DisasterAlert> activeDisasters,
  }) {
    final List<PersonalizedCard> cards = [];

    // 1. Disaster priority cards
    if (activeDisasters.isNotEmpty) {
      final topDisaster = activeDisasters.first;
      cards.add(
        PersonalizedCard(
          id: 'card-disaster',
          title: '${topDisaster.type.displayName.toUpperCase()} WARNING',
          description: topDisaster.title,
          icon: topDisaster.type.icon,
          accentColor: topDisaster.severity.color,
          priority: 100,
          actionRoute: '/advanced/disaster/${topDisaster.id}',
        ),
      );
    }

    // 2. High Rain Probability Nowcast card
    if (weather.rainProbability >= 60) {
      cards.add(
        PersonalizedCard(
          id: 'card-rain-nowcast',
          title: 'High Chance of Rain (${weather.rainProbability}%)',
          description: 'Rain showers likely soon. Check 60-minute nowcast.',
          icon: Icons.umbrella_rounded,
          accentColor: const Color(0xFF0284C7),
          priority: 90,
          actionRoute: '/advanced/nowcast',
        ),
      );
    }

    // 3. AQI Alert card
    if (weather.aqi > 120) {
      cards.add(
        PersonalizedCard(
          id: 'card-aqi',
          title: 'Unhealthy AQI Level (${weather.aqi})',
          description: 'Particulate pollution elevated. View detailed air map.',
          icon: Icons.blur_on_rounded,
          accentColor: Colors.orangeAccent,
          priority: 80,
          actionRoute: '/advanced/air-quality-map',
        ),
      );
    }

    // 4. Default Weather Intelligence Card
    cards.add(
      const PersonalizedCard(
        id: 'card-ai-assistant',
        title: 'Mausam Weather AI',
        description: 'Ask smart personalized activity advice for today.',
        icon: Icons.smart_toy_rounded,
        accentColor: Color(0xFF06B6D4),
        priority: 50,
        actionRoute: '/advanced/ai-assistant',
      ),
    );

    // Sort by priority descending
    cards.sort((a, b) => b.priority.compareTo(a.priority));
    return cards;
  }
}
