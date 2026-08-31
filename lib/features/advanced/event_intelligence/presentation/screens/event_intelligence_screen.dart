import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/core/theme/app_colors.dart';
import 'package:mausam_app/features/advanced/core/presentation/widgets/advanced_states.dart';
import 'package:mausam_app/features/advanced/event_intelligence/domain/models/event_model.dart';
import 'package:mausam_app/features/advanced/event_intelligence/domain/repositories/event_repository.dart';

class EventIntelligenceScreen extends ConsumerStatefulWidget {
  const EventIntelligenceScreen({super.key});

  @override
  ConsumerState<EventIntelligenceScreen> createState() =>
      _EventIntelligenceScreenState();
}

class _EventIntelligenceScreenState
    extends ConsumerState<EventIntelligenceScreen> {
  final TextEditingController _nameCtrl =
      TextEditingController(text: 'Outdoor Wedding & Reception');
  final TextEditingController _locCtrl =
      TextEditingController(text: 'Nehru Park, Delhi');
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  bool _isOutdoor = true;
  EventPlanReport? _report;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _evaluate();
  }

  void _evaluate() async {
    setState(() {
      _isLoading = true;
    });

    final repo = ref.read(eventIntelligenceRepositoryProvider);
    final res = await repo.evaluateEvent(
      name: _nameCtrl.text,
      location: _locCtrl.text,
      date: _selectedDate,
      isOutdoor: _isOutdoor,
    );

    if (mounted) {
      setState(() {
        _report = res;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE, MMM d, yyyy').format(_selectedDate);

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
          'AI Event Weather Planner',
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
          // Event Input Form
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
                  controller: _nameCtrl,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.event_rounded,
                        color: AppColors.cyanAccent, size: 18),
                    hintText: 'Event Name (e.g. Wedding, Sports)',
                    hintStyle:
                        TextStyle(color: AppColors.textMuted, fontSize: 12),
                    border: InputBorder.none,
                  ),
                ),
                const Divider(color: AppColors.glassBorder, height: 1),
                TextField(
                  controller: _locCtrl,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_rounded,
                        color: Colors.purpleAccent, size: 18),
                    hintText: 'Event Location',
                    hintStyle:
                        TextStyle(color: AppColors.textMuted, fontSize: 12),
                    border: InputBorder.none,
                  ),
                ),
                const Divider(color: AppColors.glassBorder, height: 1),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 30)),
                          );
                          if (d != null) {
                            setState(() {
                              _selectedDate = d;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today_rounded,
                            size: 16, color: AppColors.cyanAccent),
                        label: Text(dateStr,
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 12)),
                      ),
                    ),
                    Row(
                      children: [
                        const Text('Outdoor',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                        Switch(
                          value: _isOutdoor,
                          activeColor: AppColors.cyanAccent,
                          onChanged: (val) {
                            setState(() {
                              _isOutdoor = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _evaluate,
                    icon: const Icon(Icons.insights_rounded, size: 18),
                    label: const Text('Evaluate Event Suitability'),
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
                message: 'Simulating weather forecast model for event venue...')
          else if (_report != null) ...[
            // Report Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _report!.ratingColor.withOpacity(0.3),
                    AppColors.darkBackgroundSecondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border:
                    Border.all(color: _report!.ratingColor.withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _report!.ratingColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _report!.ratingColor),
                        ),
                        child: Text(
                          _report!.suitabilityRating.toUpperCase(),
                          style: TextStyle(
                            color: _report!.ratingColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        _report!.isOutdoor ? 'OUTDOOR EVENT' : 'INDOOR VENUE',
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _report!.eventName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _report!.summaryExplanation,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Forecast Breakdown Cards
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Rain Prob.',
                    '${_report!.rainProbability}%',
                    Icons.umbrella_rounded,
                    Colors.cyan,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    'Temp Range',
                    '${_report!.tempMin.toInt()}°–${_report!.tempMax.toInt()}°C',
                    Icons.thermostat_rounded,
                    Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Wind Speed',
                    '${_report!.windSpeedKmh} km/h',
                    Icons.air_rounded,
                    Colors.purpleAccent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    'Humidity',
                    '${_report!.humidity}%',
                    Icons.water_drop_rounded,
                    Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Disclaimer Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _report!.disclaimer,
                      style: const TextStyle(color: Colors.amber, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const DataSourceBadge(
              source: 'Mausam Event Weather Predictor',
              lastUpdated: 'Live Evaluation',
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricTile(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 10)),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
