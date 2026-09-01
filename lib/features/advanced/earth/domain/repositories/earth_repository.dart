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
        type: EarthLayerType.temperature,
        title: 'Global Surface Thermal Heatmap',
        description: 'Global thermal gradient heatmap & isotherm contours',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.precipitation,
        title: 'Doppler Radar Precipitation',
        description: 'Rainfall intensity and convective storm tracking',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.clouds,
        title: 'Global Satellite Cloud Cover',
        description: 'Infrared & visible cloud top composite imagery',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/clouds_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.wind,
        title: 'Streamline Wind Vector Flow',
        description: 'Surface wind velocity & atmospheric jetstream particle vectors',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/wind_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.humidity,
        title: 'Relative Atmospheric Humidity',
        description: 'Moisture density and dew point distribution',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/humidity_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.pressure,
        title: 'Sea-Level Barometric Pressure',
        description: 'Isobar contours and High/Low pressure system cells',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/pressure_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.airQuality,
        title: 'Particulate Air Quality Index (AQI)',
        description: 'PM2.5 / PM10 atmospheric concentration heatmap',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/air_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.uv,
        title: 'Solar UV Radiation Index',
        description: 'Global ultraviolet exposure & erythemal irradiance map',
        tileUrlTemplate:
            'https://tile.openweathermap.org/map/uv_new/{z}/{x}/{y}.png',
      ),
      EarthLayer(
        type: EarthLayerType.alerts,
        title: 'Severe Weather Emergency Advisories',
        description: 'IMD & global meteorological warning zones',
        tileUrlTemplate: '',
      ),
      EarthLayer(
        type: EarthLayerType.cyclones,
        title: 'Tropical Cyclone Track Vectors',
        description: 'Active storm trajectories, wind radiuses & landfall forecasts',
        tileUrlTemplate: '',
      ),
      EarthLayer(
        type: EarthLayerType.lightning,
        title: 'Real-Time Lightning Strike Density',
        description: 'Thunderstorm cell discharge locations & strike frequency',
        tileUrlTemplate: '',
      ),
      EarthLayer(
        type: EarthLayerType.visibility,
        title: 'Surface Atmospheric Visibility',
        description: 'Visibility range in km for highway & aviation routing',
        tileUrlTemplate: '',
      ),
      EarthLayer(
        type: EarthLayerType.marine,
        title: 'Ocean Swell & Marine Waves',
        description: 'Sea-surface temperatures, wave height & coastal tides',
        tileUrlTemplate: '',
      ),
      EarthLayer(
        type: EarthLayerType.soil,
        title: 'Agricultural Soil Moisture',
        description: 'Topsoil moisture percentage for irrigation & crop planning',
        tileUrlTemplate: '',
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

