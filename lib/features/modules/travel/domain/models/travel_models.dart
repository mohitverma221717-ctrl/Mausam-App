class TravelDestination {
  final String id;
  final String city;
  final String country;
  final double currentTemp;
  final String condition;
  final int rainChance;
  final String travelDates; // "28 Aug – 02 Sep"
  final List<String> packingSuggestions;
  final String? severeAlert;

  const TravelDestination({
    required this.id,
    required this.city,
    required this.country,
    required this.currentTemp,
    required this.condition,
    required this.rainChance,
    required this.travelDates,
    required this.packingSuggestions,
    this.severeAlert,
  });
}

class TravelData {
  final List<TravelDestination> savedDestinations;
  final String packingSummary;
  final String flightWeatherVerdict; // "Smooth weather expected along route"

  const TravelData({
    required this.savedDestinations,
    required this.packingSummary,
    required this.flightWeatherVerdict,
  });
}
