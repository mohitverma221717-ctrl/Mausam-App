import '../../domain/models/travel_models.dart';

class MockTravelRepository {
  Future<TravelData> getTravelData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const TravelData(
      savedDestinations: [
        TravelDestination(
          id: 'dest-london',
          city: 'London',
          country: 'United Kingdom',
          currentTemp: 18.0,
          condition: 'Rain Likely',
          rainChance: 70,
          travelDates: '28 Aug – 02 Sep',
          packingSuggestions: [
            'Carry a raincoat',
            'Light jacket',
            'Windproof umbrella',
            'Water-resistant footwear',
          ],
          severeAlert: 'Intermittent rainfall warnings for South East England',
        ),
        TravelDestination(
          id: 'dest-tokyo',
          city: 'Tokyo',
          country: 'Japan',
          currentTemp: 27.0,
          condition: 'Partly Cloudy',
          rainChance: 25,
          travelDates: '10 Sep – 16 Sep',
          packingSuggestions: [
            'Breathable cotton wear',
            'Sun protection / SPF 50',
            'Compact umbrella',
          ],
        ),
        TravelDestination(
          id: 'dest-dubai',
          city: 'Dubai',
          country: 'UAE',
          currentTemp: 38.0,
          condition: 'Hot & Sunny',
          rainChance: 0,
          travelDates: '20 Sep – 25 Sep',
          packingSuggestions: [
            'Lightweight sunglasses',
            'UV protective shirts',
            'Hydration flask',
          ],
        ),
      ],
      packingSummary:
          'Based on destination forecast: Waterproof essentials recommended for London.',
      flightWeatherVerdict:
          'No flight route weather delays anticipated across main corridors.',
    );
  }
}
