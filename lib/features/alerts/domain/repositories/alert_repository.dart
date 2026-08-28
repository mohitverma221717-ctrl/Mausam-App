import '../models/weather_alert.dart';
import '../../../location/domain/models/location_model.dart';

abstract class AlertRepository {
  Future<List<WeatherAlert>> getActiveAlerts(LocationModel location);
  Future<List<WeatherAlert>> getAlertHistory(LocationModel location);
  Future<List<NotificationItem>> getNotifications();
  Future<void> markAlertAsRead(String id);
  Future<void> markNotificationAsRead(String id);
  Future<void> clearAllNotifications();
}
