import 'package:flutter/material.dart';

enum UserInterest {
  health,
  fitness,
  marine,
  travel,
  family,
  agriculture,
  commute,
  eventPlanner,
}

extension UserInterestX on UserInterest {
  String get id => name;

  String get displayName {
    switch (this) {
      case UserInterest.health:
        return 'Health';
      case UserInterest.fitness:
        return 'Fitness';
      case UserInterest.marine:
        return 'Marine';
      case UserInterest.travel:
        return 'Travel';
      case UserInterest.family:
        return 'Family';
      case UserInterest.agriculture:
        return 'Agriculture';
      case UserInterest.commute:
        return 'Commute';
      case UserInterest.eventPlanner:
        return 'Event Planner';
    }
  }

  String get description {
    switch (this) {
      case UserInterest.health:
        return 'AQI, Pollen count, UV index, respiratory risk & medical advisories';
      case UserInterest.fitness:
        return 'Best running hours, Heat index, wind resistance & outdoor sports';
      case UserInterest.marine:
        return 'Tide forecasts, wave heights, water temp & sea conditions';
      case UserInterest.travel:
        return 'Destination forecasts, rain chance & automated packing guides';
      case UserInterest.family:
        return 'School commute status, morning temperature & storm alerts';
      case UserInterest.agriculture:
        return 'Soil moisture, frost risk, seasonal planting & rainfall timing';
      case UserInterest.commute:
        return 'Route weather, fog alerts, road visibility & traffic status';
      case UserInterest.eventPlanner:
        return 'Multi-day outlook, rain probability & outdoor comfort index';
    }
  }

  IconData get iconData {
    switch (this) {
      case UserInterest.health:
        return Icons.favorite_rounded;
      case UserInterest.fitness:
        return Icons.directions_run_rounded;
      case UserInterest.marine:
        return Icons.waves_rounded;
      case UserInterest.travel:
        return Icons.flight_takeoff_rounded;
      case UserInterest.family:
        return Icons.family_restroom_rounded;
      case UserInterest.agriculture:
        return Icons.agriculture_rounded;
      case UserInterest.commute:
        return Icons.directions_car_rounded;
      case UserInterest.eventPlanner:
        return Icons.event_available_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case UserInterest.health:
        return const Color(0xFF00E676);
      case UserInterest.fitness:
        return const Color(0xFFFF9100);
      case UserInterest.marine:
        return const Color(0xFF00E5FF);
      case UserInterest.travel:
        return const Color(0xFF2979FF);
      case UserInterest.family:
        return const Color(0xFFFF4081);
      case UserInterest.agriculture:
        return const Color(0xFF76FF03);
      case UserInterest.commute:
        return const Color(0xFFFFB300);
      case UserInterest.eventPlanner:
        return const Color(0xFFD500F9);
    }
  }

  String get routePath {
    switch (this) {
      case UserInterest.health:
        return '/explore/health';
      case UserInterest.fitness:
        return '/explore/fitness';
      case UserInterest.marine:
        return '/explore/marine';
      case UserInterest.travel:
        return '/explore/travel';
      case UserInterest.family:
        return '/explore/family';
      case UserInterest.agriculture:
        return '/explore/agriculture';
      case UserInterest.commute:
        return '/explore/commute';
      case UserInterest.eventPlanner:
        return '/explore/event-planner';
    }
  }
}

class PriorityRule {
  final UserInterest interest;
  final int rank; // 1 (highest) to 8
  final double weight; // dynamic weight 0.0 - 1.0
  final bool isEnabled;

  const PriorityRule({
    required this.interest,
    required this.rank,
    this.weight = 1.0,
    this.isEnabled = true,
  });

  PriorityRule copyWith({
    int? rank,
    double? weight,
    bool? isEnabled,
  }) {
    return PriorityRule(
      interest: interest,
      rank: rank ?? this.rank,
      weight: weight ?? this.weight,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class PersonalizedCardData {
  final String id;
  final UserInterest interest;
  final String title;
  final String subtitle;
  final IconData icon;
  final double priorityScore; // computed dynamic score
  final Map<String, String> metrics;
  final String primaryActionRoute;
  final String? badgeText;
  final Color? badgeColor;

  const PersonalizedCardData({
    required this.id,
    required this.interest,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.priorityScore,
    required this.metrics,
    required this.primaryActionRoute,
    this.badgeText,
    this.badgeColor,
  });
}
