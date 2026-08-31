
class NowcastData {
  final bool isRainExpectedSoon;
  final String
      rainWindowText; // e.g. "Rain may reach this area within the next 30–45 minutes."
  final String shortTermTrend; // Increasing, Decreasing, Steady
  final int rainProbability;
  final String intensityCategory; // Light, Moderate, Heavy
  final List<NowcastTimelineStep> timeline;
  final String source;
  final DateTime lastUpdated;

  const NowcastData({
    required this.isRainExpectedSoon,
    required this.rainWindowText,
    required this.shortTermTrend,
    required this.rainProbability,
    required this.intensityCategory,
    required this.timeline,
    required this.source,
    required this.lastUpdated,
  });
}

class NowcastTimelineStep {
  final String minutesOffset; // "+15 min", "+30 min"
  final String status;
  final double rainAmountMm;

  const NowcastTimelineStep({
    required this.minutesOffset,
    required this.status,
    required this.rainAmountMm,
  });
}
