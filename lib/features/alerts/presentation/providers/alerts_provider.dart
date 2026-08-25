import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/weather_alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../../data/repositories/mock_alert_repository.dart';
import '../../../location/presentation/providers/location_provider.dart';

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  return MockAlertRepository();
});

class AlertsState {
  final bool isLoading;
  final List<WeatherAlert> activeAlerts;
  final List<WeatherAlert> alertHistory;
  final List<NotificationItem> notifications;
  final AlertSeverity? filterSeverity;

  const AlertsState({
    this.isLoading = false,
    this.activeAlerts = const [],
    this.alertHistory = const [],
    this.notifications = const [],
    this.filterSeverity,
  });

  int get unreadAlertsCount => activeAlerts.where((a) => !a.isRead).length;
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  List<WeatherAlert> get filteredAlerts {
    if (filterSeverity == null) return activeAlerts;
    return activeAlerts.where((a) => a.severity == filterSeverity).toList();
  }

  AlertsState copyWith({
    bool? isLoading,
    List<WeatherAlert>? activeAlerts,
    List<WeatherAlert>? alertHistory,
    List<NotificationItem>? notifications,
    AlertSeverity? filterSeverity,
    bool clearFilter = false,
  }) {
    return AlertsState(
      isLoading: isLoading ?? this.isLoading,
      activeAlerts: activeAlerts ?? this.activeAlerts,
      alertHistory: alertHistory ?? this.alertHistory,
      notifications: notifications ?? this.notifications,
      filterSeverity:
          clearFilter ? null : (filterSeverity ?? this.filterSeverity),
    );
  }
}

class AlertsNotifier extends StateNotifier<AlertsState> {
  final AlertRepository _repository;
  final Ref _ref;

  AlertsNotifier(this._repository, this._ref) : super(const AlertsState()) {
    _init();
  }

  void _init() {
    _ref.listen(locationProvider.select((s) => s.selectedLocation),
        (prev, next) {
      loadAlerts();
    });
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    state = state.copyWith(isLoading: true);
    final location = _ref.read(locationProvider).selectedLocation;
    final active = await _repository.getActiveAlerts(location);
    final history = await _repository.getAlertHistory(location);
    final notifs = await _repository.getNotifications();

    state = state.copyWith(
      isLoading: false,
      activeAlerts: active,
      alertHistory: history,
      notifications: notifs,
    );
  }

  void setFilterSeverity(AlertSeverity? severity) {
    if (severity == state.filterSeverity) {
      state = state.copyWith(clearFilter: true);
    } else {
      state = state.copyWith(filterSeverity: severity);
    }
  }

  Future<void> markAlertAsRead(String id) async {
    await _repository.markAlertAsRead(id);
    await loadAlerts();
  }

  Future<void> markNotificationAsRead(String id) async {
    await _repository.markNotificationAsRead(id);
    await loadAlerts();
  }

  Future<void> clearAllNotifications() async {
    await _repository.clearAllNotifications();
    state = state.copyWith(notifications: []);
  }
}

final alertsProvider =
    StateNotifierProvider<AlertsNotifier, AlertsState>((ref) {
  final repo = ref.watch(alertRepositoryProvider);
  return AlertsNotifier(repo, ref);
});
