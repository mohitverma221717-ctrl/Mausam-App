import 'package:flutter/material.dart';
import '../models/personalization_models.dart';
import '../../../weather/domain/models/weather_data.dart';
import '../../../alerts/domain/models/weather_alert.dart';

/// Dynamic Personalization & Scoring Engine for MAUSAM Home Dashboard
class PersonalizationEngine {
  static List<PersonalizedCardData> computePersonalizedCards({
    required List<UserInterest> selectedInterests,
    required List<PriorityRule> priorityRules,
    required WeatherData weather,
    required List<WeatherAlert> activeAlerts,
  }) {
    if (selectedInterests.isEmpty) {
      // Default to Health & Fitness if none selected
      selectedInterests = [UserInterest.health, UserInterest.fitness];
    }

    final List<PersonalizedCardData> cards = [];

    // Check for severe conditions
    final hasRainAlert =
        activeAlerts.any((a) => a.title.toLowerCase().contains('rain'));
    final isHighUv = weather.uvIndex >= 6;
    final isPoorAqi = weather.aqi > 100;
    final isHighHeat = weather.temperature >= 35;

    for (final interest in selectedInterests) {
      // Base rank priority: rank 1 has base 100, rank 2 has 90, etc.
      final rule = priorityRules.firstWhere(
        (r) => r.interest == interest,
        orElse: () => PriorityRule(
          interest: interest,
          rank: selectedInterests.indexOf(interest) + 1,
        ),
      );

      double score = 100.0 - (rule.rank * 10);

      switch (interest) {
        case UserInterest.health:
          if (isPoorAqi) score += 25;
          if (isHighUv) score += 15;
          cards.add(
            PersonalizedCardData(
              id: 'card-health',
              interest: UserInterest.health,
              title: 'Health Dashboard',
              subtitle: weather.aqi <= 100
                  ? 'Air quality is good today. Ideal for outdoor activities.'
                  : 'Elevated AQI detected. Sensitive groups should wear masks.',
              icon: Icons.favorite_rounded,
              priorityScore: score,
              badgeText: 'AQI ${weather.aqi} • ${weather.aqiStatus}',
              badgeColor: const Color(0xFF00E676),
              primaryActionRoute: '/explore/health',
              metrics: {
                'AQI': '${weather.aqi}',
                'UV Index': '${weather.uvIndex}',
                'Humidity': '${weather.humidity}%',
                'Pollen': 'Low Risk',
              },
            ),
          );
          break;

        case UserInterest.fitness:
          if (isHighHeat) score -= 10;
          cards.add(
            PersonalizedCardData(
              id: 'card-fitness',
              interest: UserInterest.fitness,
              title: 'Best Running Hours',
              subtitle:
                  '6:00 AM – 8:00 AM • Perfect time for running & workouts',
              icon: Icons.directions_run_rounded,
              priorityScore: score,
              badgeText: 'Good Conditions',
              badgeColor: const Color(0xFFFF9100),
              primaryActionRoute: '/explore/fitness',
              metrics: {
                'Window': '6:00 - 8:00 AM',
                'Temp': '${weather.temperature.toInt()}°C',
                'Wind': '${weather.windSpeed.toInt()} km/h',
                'Heat Index': '${(weather.feelsLike).toInt()}°C',
              },
            ),
          );
          break;

        case UserInterest.marine:
          cards.add(
            const PersonalizedCardData(
              id: 'card-marine',
              interest: UserInterest.marine,
              title: 'Marine & Sea Conditions',
              subtitle:
                  'Clean swell peelers. Safe for coastal sailing & surfing.',
              icon: Icons.waves_rounded,
              priorityScore: 70,
              badgeText: 'Sea: Good',
              badgeColor: Color(0xFF00E5FF),
              primaryActionRoute: '/explore/marine',
              metrics: {
                'Wave': '1.2 m',
                'Wind': '18 km/h',
                'Water': '28°C',
                'High Tide': '5:30 PM',
              },
            ),
          );
          break;

        case UserInterest.travel:
          cards.add(
            const PersonalizedCardData(
              id: 'card-travel',
              interest: UserInterest.travel,
              title: 'Travel: London, UK',
              subtitle:
                  'Rain expected this weekend. Pack umbrella & light jacket.',
              icon: Icons.flight_takeoff_rounded,
              priorityScore: 75,
              badgeText: 'Rain Likely 70%',
              badgeColor: Color(0xFF2979FF),
              primaryActionRoute: '/explore/travel',
              metrics: {
                'Temp': '18°C',
                'Rain': '70%',
                'Packing': 'Raincoat, Umbrella',
                'Flight': 'On Time',
              },
            ),
          );
          break;

        case UserInterest.family:
          if (hasRainAlert) score += 20;
          cards.add(
            PersonalizedCardData(
              id: 'card-family',
              interest: UserInterest.family,
              title: 'Family & School Commute',
              subtitle: hasRainAlert
                  ? 'Rain expected around afternoon pick-up time.'
                  : 'Good morning conditions across all school routes.',
              icon: Icons.family_restroom_rounded,
              priorityScore: score,
              badgeText: 'Good Conditions',
              badgeColor: const Color(0xFFFF4081),
              primaryActionRoute: '/explore/family',
              metrics: {
                'Morning': '${weather.tempMin.toInt()}°C',
                'Rain Chance': '${weather.rainProbability}%',
                'Visibility': '${weather.visibility.toInt()} km',
                'Safety': 'Clear',
              },
            ),
          );
          break;

        case UserInterest.agriculture:
          cards.add(
            const PersonalizedCardData(
              id: 'card-agriculture',
              interest: UserInterest.agriculture,
              title: 'Agriculture & Farm Weather',
              subtitle: 'Optimal soil moisture for wheat sowing and soil prep.',
              icon: Icons.agriculture_rounded,
              priorityScore: 80,
              badgeText: 'Sensor Connected',
              badgeColor: Color(0xFF76FF03),
              primaryActionRoute: '/explore/agriculture',
              metrics: {
                'Rain Forecast': '72%',
                'Soil Moisture': '42%',
                'Frost Risk': 'Low',
                'Farm Temp': '28°C',
              },
            ),
          );
          break;

        case UserInterest.commute:
          if (hasRainAlert) score += 20;
          cards.add(
            PersonalizedCardData(
              id: 'card-commute',
              interest: UserInterest.commute,
              title: 'Commute: Home → College / Work',
              subtitle:
                  'Moderate traffic. Clean visibility across bypass roads.',
              icon: Icons.directions_car_rounded,
              priorityScore: score,
              badgeText: 'Moderate Conditions',
              badgeColor: const Color(0xFFFFB300),
              primaryActionRoute: '/explore/commute',
              metrics: {
                'Traffic': 'Moderate',
                'Rain': '${weather.rainProbability}%',
                'Visibility': '${weather.visibility.toInt()} km',
                'Wind': '${weather.windSpeed.toInt()} km/h',
              },
            ),
          );
          break;

        case UserInterest.eventPlanner:
          cards.add(
            const PersonalizedCardData(
              id: 'card-event',
              interest: UserInterest.eventPlanner,
              title: 'Event: Wedding & Outdoor Outlook',
              subtitle:
                  'Comfort index is good. Low rain risk for evening event.',
              icon: Icons.event_available_rounded,
              priorityScore: 78,
              badgeText: 'Outdoor: Suitable',
              badgeColor: Color(0xFFD500F9),
              primaryActionRoute: '/explore/event-planner',
              metrics: {
                'Comfort': 'Good',
                'Rain Risk': '20%',
                'Temp': '29°C',
                'Wind': '12 km/h',
              },
            ),
          );
          break;
      }
    }

    // Sort descending by dynamic priority score
    cards.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    return cards;
  }
}
