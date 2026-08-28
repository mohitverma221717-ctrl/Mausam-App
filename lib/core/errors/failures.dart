/// Base Failure class for Clean Architecture domain error mapping
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(
      [super.message = 'Server communication error. Please try again.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure(
      [super.message = 'No Internet connection. Showing cached weather.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to retrieve cached data.']);
}

class LocationFailure extends Failure {
  const LocationFailure(
      [super.message = 'Unable to fetch location coordinates.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure(
      [super.message = 'Location permission is required for local weather.']);
}

class AuthFailure extends Failure {
  const AuthFailure(
      [super.message =
          'Authentication failed. Please check your credentials.']);
}
