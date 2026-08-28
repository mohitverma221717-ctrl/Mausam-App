import '../../domain/models/weather_alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../../../location/domain/models/location_model.dart';

class MockAlertRepository implements AlertRepository {
  final List<WeatherAlert> _alerts = [
    WeatherAlert(
      id: 'alert-1',
      title: 'Heavy Rain Alert',
      type: 'Rainstorm & Thunder',
      severity: AlertSeverity.high,
      location: 'Lucknow & nearby areas',
      timeRange: 'Expected 8:00 PM – 11:00 PM',
      description:
          'Intense rainfall accompanied by gusty winds (up to 45 km/h) and lightning expected over northern districts.',
      advisory:
          'Avoid low-lying roads and waterlogged underpasses. Secure loose outdoor objects.',
      startTime: DateTime.now().subtract(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      source: 'India Meteorological Department (IMD)',
      isRead: false,
    ),
    WeatherAlert(
      id: 'alert-2',
      title: 'Heat Wave Advisory',
      type: 'Thermal Stress',
      severity: AlertSeverity.moderate,
      location: 'North India & UP Plains',
      timeRange: '11:30 AM – 04:30 PM',
      description:
          'Maximum temperatures anticipated to touch 36°C with elevated humidity leading to heat index exceeding 41°C.',
      advisory:
          'Stay hydrated. Avoid direct sun exposure during peak noon hours.',
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 6)),
      source: 'State Disaster Management Authority',
      isRead: false,
    ),
    WeatherAlert(
      id: 'alert-3',
      title: 'Fog Alert',
      type: 'Dense Fog & Low Visibility',
      severity: AlertSeverity.low,
      location: 'Early-morning in Eastern UP',
      timeRange: '04:00 AM – 07:30 AM',
      description:
          'Shallow to moderate fog formation likely in riverine and rural highways causing visibility drops below 800m.',
      advisory:
          'Use fog lights while commuting and maintain safe vehicle distance.',
      startTime: DateTime.now().subtract(const Duration(hours: 8)),
      endTime: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'National Weather Bureau',
      isRead: true,
    ),
  ];

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif-1',
      title: 'Heavy Rain Alert Updated',
      body: 'Thunderstorm warning extended till 11:30 PM for Lucknow region.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      category: 'Alerts',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif-2',
      title: 'Daily Morning Briefing',
      body:
          'Today: 29°C, Partly Cloudy. Best time for outdoor fitness: 6:00 AM - 8:00 AM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      category: 'Summary',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif-3',
      title: 'AQI Update: Good (82)',
      body:
          'Air quality in your area is clean and safe for all outdoor activities.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      category: 'Health',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif-4',
      title: 'Travel Alert: London',
      body: 'Light rain expected across central London this weekend.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Travel',
      isRead: true,
    ),
  ];

  @override
  Future<List<WeatherAlert>> getActiveAlerts(LocationModel location) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _alerts.where((a) => a.endTime.isAfter(DateTime.now())).toList();
  }

  @override
  Future<List<WeatherAlert>> getAlertHistory(LocationModel location) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _alerts;
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _notifications;
  }

  @override
  Future<void> markAlertAsRead(String id) async {
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _alerts[idx] = _alerts[idx].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
    }
  }

  @override
  Future<void> clearAllNotifications() async {
    _notifications.clear();
  }
}
