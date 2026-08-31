import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/earth_layer_model.dart';

abstract class EarthRepository {
  Future<List<EarthLayer>> getAvailableLayers();
}

class MockEarthRepository implements EarthRepository {
  @override
  Future<List<EarthLayer>> getAvailableLayers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      EarthLayer(
        type: EarthLayerType.clouds,
        title: 'Global Satellite Cloud Cover',
        description: 'Infrared & visible cloud top composite imagery',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/clouds_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.precipitation,
        title: 'Doppler Radar Precipitation',
        description: 'Rainfall intensity and convective storm tracking',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.temperature,
        title: 'Surface Temperature Isobars',
        description: 'Global thermal gradient heatmap',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.wind,
        title: 'Streamline Wind Vector',
        description: 'Surface wind velocity & atmospheric jetstreams',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/wind_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.airQuality,
        title: 'Particulate Air Quality Overlay',
        description: 'PM2.5 / PM10 atmospheric concentration',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/air_new/{z}/{x}/{y}.png',
      ),
    ];
  }
}

final earthRepositoryProvider = Provider<EarthRepository>((ref) {
  return MockEarthRepository();
});

final availableEarthLayersProvider =
    FutureProvider<List<EarthLayer>>((ref) async {
  final repo = ref.watch(earthRepositoryProvider);
  return repo.getAvailableLayers();
});
