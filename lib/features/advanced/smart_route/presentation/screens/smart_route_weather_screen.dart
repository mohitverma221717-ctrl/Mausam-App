import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/smart_route/domain/models/route_model.dart';
import 'package:mausam_app/features/advanced/smart_route/domain/repositories/route_repository.dart';

class SmartRouteWeatherScreen extends ConsumerStatefulWidget {
  const SmartRouteWeatherScreen({super.key});

  @override
  ConsumerState<SmartRouteWeatherScreen> createState() =>
      _SmartRouteWeatherScreenState();
}

class _SmartRouteWeatherScreenState
    extends ConsumerState<SmartRouteWeatherScreen> {
  final TextEditingController _originCtrl =
      TextEditingController(text: 'Home (Connaught Place)');
  final TextEditingController _destCtrl =
      TextEditingController(text: 'Work (Cyber City)');
  RouteWeatherReport? _report;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  void _fetchRoute() async {
    setState(() {
      _isLoading = true;
    });

    final repo = ref.read(routeRepositoryProvider);
    final result = await repo.getRouteWeather(_originCtrl.text, _destCtrl.text);

    if (mounted) {
      setState(() {
        _report = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackgroundSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Smart Route Weather',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Input Form Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkBackgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _originCtrl,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.my_location_rounded,
                        color: AppColors.cyanAccent, size: 18),
                    hintText: 'Enter Starting Point (e.g. Home)',
                    hintStyle:
                        TextStyle(color: AppColors.textMuted, fontSize: 12),
                    border: InputBorder.none,
                  ),
                ),
                const Divider(color: AppColors.glassBorder, height: 1),
                TextField(
                  controller: _destCtrl,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_rounded,
                        color: Colors.redAccent, size: 18),
                    hintText: 'Enter Destination (e.g. Work/College)',
                    hintStyle:
                        TextStyle(color: AppColors.textMuted, fontSize: 12),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _fetchRoute,
                    icon: const Icon(Icons.alt_route_rounded, size: 18),
                    label: const Text('Analyze Route Weather'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyanAccent,
                      foregroundColor: AppColors.darkBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_isLoading)
            const AdvancedLoadingState(
                message:
                    'Calculating weather conditions along route waypoints...')
          else if (_report != null) ...[
            // Route Summary Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0369A1).withOpacity(0.4),
                    AppColors.darkBackgroundSecondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.cyanAccent.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distance: ${_report!.totalDistanceKm} km',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Est. Travel Time: ${_report!.estimatedTravelTime}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orangeAccent),
                    ),
                    child: Text(
                      _report!.overallHazardLevel.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Waypoints Timeline
            const Text(
              'Route Waypoint Forecast',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._report!.waypoints.map((wp) => _buildWaypointCard(wp)),

            const SizedBox(height: 20),
            DataSourceBadge(
              source: _report!.source,
              lastUpdated: 'Live Waypoint Feed',
              isDemo: true,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildWaypointCard(RouteWaypoint wp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                wp.locationName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${wp.temperature.toInt()}°C',
                style: const TextStyle(
                  color: AppColors.cyanAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${wp.condition} • Rain Prob: ${wp.rainProbability}% • Vis: ${wp.visibilityKm} km',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          if (wp.hazardWarning.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_rounded,
                      color: Colors.redAccent, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      wp.hazardWarning,
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
