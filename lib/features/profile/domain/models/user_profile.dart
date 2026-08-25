import '../../../personalization/domain/models/personalization_models.dart';
import '../../../location/domain/models/location_model.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final List<UserInterest> interests;
  final LocationModel? primaryLocation;
  final bool isNotificationsEnabled;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.interests,
    this.primaryLocation,
    this.isNotificationsEnabled = true,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<UserInterest>? interests,
    LocationModel? primaryLocation,
    bool? isNotificationsEnabled,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      interests: interests ?? this.interests,
      primaryLocation: primaryLocation ?? this.primaryLocation,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
    );
  }
}
