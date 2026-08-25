import 'package:flutter/material.dart';

enum LocationCategory {
  current,
  home,
  work,
  college,
  travel,
  custom,
}

extension LocationCategoryX on LocationCategory {
  String get displayName {
    switch (this) {
      case LocationCategory.current:
        return 'Current Location';
      case LocationCategory.home:
        return 'Home';
      case LocationCategory.work:
        return 'Work';
      case LocationCategory.college:
        return 'College';
      case LocationCategory.travel:
        return 'Travel';
      case LocationCategory.custom:
        return 'Other';
    }
  }

  IconData get iconData {
    switch (this) {
      case LocationCategory.current:
        return Icons.my_location_rounded;
      case LocationCategory.home:
        return Icons.home_rounded;
      case LocationCategory.work:
        return Icons.business_center_rounded;
      case LocationCategory.college:
        return Icons.school_rounded;
      case LocationCategory.travel:
        return Icons.flight_takeoff_rounded;
      case LocationCategory.custom:
        return Icons.place_rounded;
    }
  }
}

class LocationModel {
  final String id;
  final String name; // e.g. "Lucknow"
  final String state; // e.g. "Uttar Pradesh"
  final String country; // e.g. "India"
  final double lat;
  final double lon;
  final bool isCurrentLocation;
  final LocationCategory category;
  final double? currentTemp;
  final String? currentCondition;

  const LocationModel({
    required this.id,
    required this.name,
    required this.state,
    required this.country,
    required this.lat,
    required this.lon,
    this.isCurrentLocation = false,
    this.category = LocationCategory.custom,
    this.currentTemp,
    this.currentCondition,
  });

  String get formattedAddress => '$name, $state';
  String get fullAddress => '$name, $state, $country';

  LocationModel copyWith({
    String? name,
    String? state,
    String? country,
    double? lat,
    double? lon,
    bool? isCurrentLocation,
    LocationCategory? category,
    double? currentTemp,
    String? currentCondition,
  }) {
    return LocationModel(
      id: id,
      name: name ?? this.name,
      state: state ?? this.state,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
      category: category ?? this.category,
      currentTemp: currentTemp ?? this.currentTemp,
      currentCondition: currentCondition ?? this.currentCondition,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'country': country,
      'lat': lat,
      'lon': lon,
      'isCurrentLocation': isCurrentLocation,
      'category': category.name,
      'currentTemp': currentTemp,
      'currentCondition': currentCondition,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
      category: LocationCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => LocationCategory.custom,
      ),
      currentTemp: (json['currentTemp'] as num?)?.toDouble(),
      currentCondition: json['currentCondition'] as String?,
    );
  }
}
