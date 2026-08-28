import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../profile/domain/models/user_profile.dart';
import '../../../personalization/domain/models/personalization_models.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isFirstTime;
  final UserProfile? user;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated =
        true, // Default to true for instant exploration if desired or set during setup
    this.isFirstTime = true,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isFirstTime,
    UserProfile? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  void _init() {
    final isFirst = StorageService.getBool(StorageService.keyIsFirstTime,
        defaultValue: true);
    final isAuth = StorageService.getBool(StorageService.keyIsAuthenticated,
        defaultValue: false);

    state = state.copyWith(
      isFirstTime: isFirst,
      isAuthenticated: isAuth,
      user: const UserProfile(
        id: 'usr-aarav-01',
        name: 'Aarav Sharma',
        email: 'aarav@gmail.com',
        phone: '+91 9876543210',
        avatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
        interests: [
          UserInterest.health,
          UserInterest.fitness,
          UserInterest.travel,
          UserInterest.agriculture,
          UserInterest.commute,
          UserInterest.eventPlanner,
        ],
      ),
    );
  }

  Future<void> completeOnboarding() async {
    await StorageService.setBool(StorageService.keyIsFirstTime, false);
    state = state.copyWith(isFirstTime: false);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Please fill in all fields.');
      return false;
    }

    await StorageService.setBool(StorageService.keyIsAuthenticated, true);
    await StorageService.writeSecure(
        StorageService.secureAuthToken, 'sample_jwt_token_mausam_2026');

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
    );
    return true;
  }

  Future<bool> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Please fill in all fields.');
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      user: state.user?.copyWith(name: name, email: email) ??
          UserProfile(
            id: 'usr-new-01',
            name: name,
            email: email,
            phone: '',
            avatarUrl: '',
            interests: [UserInterest.health, UserInterest.fitness],
          ),
    );
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 500));

    if (otp.length < 6) {
      state =
          state.copyWith(isLoading: false, errorMessage: 'Invalid OTP code.');
      return false;
    }

    await StorageService.setBool(StorageService.keyIsAuthenticated, true);
    state = state.copyWith(isLoading: false, isAuthenticated: true);
    return true;
  }

  Future<void> updateProfile(
      {String? name, String? email, String? phone}) async {
    state = state.copyWith(
      user: state.user?.copyWith(
        name: name,
        email: email,
        phone: phone,
      ),
    );
  }

  Future<void> updateInterests(List<UserInterest> interests) async {
    state = state.copyWith(
      user: state.user?.copyWith(interests: interests),
    );
    final strList = interests.map((e) => e.name).toList();
    await StorageService.setStringList(
        StorageService.keyUserInterests, strList);
  }

  Future<void> logout() async {
    await StorageService.setBool(StorageService.keyIsAuthenticated, false);
    await StorageService.deleteSecure(StorageService.secureAuthToken);
    state = state.copyWith(isAuthenticated: false);
  }

  Future<void> deleteAccount() async {
    await StorageService.clearAll();
    state = const AuthState(isAuthenticated: false, isFirstTime: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
