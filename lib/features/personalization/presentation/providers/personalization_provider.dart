import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/personalization_models.dart';
import '../../domain/services/personalization_engine.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../alerts/presentation/providers/alerts_provider.dart';
import '../../../../core/storage/storage_service.dart';

class PersonalizationState {
  final List<UserInterest> selectedInterests;
  final List<PriorityRule> priorityRules;
  final List<PersonalizedCardData> personalizedCards;
  final bool isConfigured;

  const PersonalizationState({
    required this.selectedInterests,
    required this.priorityRules,
    this.personalizedCards = const [],
    this.isConfigured = false,
  });

  PersonalizationState copyWith({
    List<UserInterest>? selectedInterests,
    List<PriorityRule>? priorityRules,
    List<PersonalizedCardData>? personalizedCards,
    bool? isConfigured,
  }) {
    return PersonalizationState(
      selectedInterests: selectedInterests ?? this.selectedInterests,
      priorityRules: priorityRules ?? this.priorityRules,
      personalizedCards: personalizedCards ?? this.personalizedCards,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }
}

class PersonalizationNotifier extends StateNotifier<PersonalizationState> {
  final Ref _ref;

  PersonalizationNotifier(this._ref)
      : super(
          const PersonalizationState(
            selectedInterests: [
              UserInterest.health,
              UserInterest.fitness,
              UserInterest.travel,
              UserInterest.agriculture,
              UserInterest.commute,
              UserInterest.eventPlanner,
            ],
            priorityRules: [
              PriorityRule(interest: UserInterest.health, rank: 1),
              PriorityRule(interest: UserInterest.fitness, rank: 2),
              PriorityRule(interest: UserInterest.travel, rank: 3),
              PriorityRule(interest: UserInterest.agriculture, rank: 4),
              PriorityRule(interest: UserInterest.commute, rank: 5),
              PriorityRule(interest: UserInterest.eventPlanner, rank: 6),
              PriorityRule(interest: UserInterest.marine, rank: 7),
              PriorityRule(interest: UserInterest.family, rank: 8),
            ],
          ),
        ) {
    _loadFromStorage();
    _ref.listen(weatherProvider, (prev, next) => _recomputeCards());
    _ref.listen(alertsProvider, (prev, next) => _recomputeCards());
  }

  void _loadFromStorage() {
    final savedInterests =
        StorageService.getStringList(StorageService.keyUserInterests);
    if (savedInterests.isNotEmpty) {
      final list = savedInterests
          .map((str) => UserInterest.values.firstWhere(
                (e) => e.name == str,
                orElse: () => UserInterest.health,
              ))
          .toList();
      state = state.copyWith(
        selectedInterests: list,
        isConfigured: true,
      );
    }
    _recomputeCards();
  }

  void toggleInterest(UserInterest interest) {
    final current = List<UserInterest>.from(state.selectedInterests);
    if (current.contains(interest)) {
      if (current.length > 1) {
        current.remove(interest);
      }
    } else {
      current.add(interest);
    }
    state = state.copyWith(selectedInterests: current);
    _recomputeCards();
  }

  void setInterests(List<UserInterest> interests) {
    state = state.copyWith(selectedInterests: interests, isConfigured: true);
    final strList = interests.map((e) => e.name).toList();
    StorageService.setStringList(StorageService.keyUserInterests, strList);
    _recomputeCards();
  }

  void reorderPriorityRules(int oldIndex, int newIndex) {
    final list = List<PriorityRule>.from(state.priorityRules);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    // Update ranks
    final updated = list.asMap().entries.map((e) {
      return e.value.copyWith(rank: e.key + 1);
    }).toList();

    state = state.copyWith(priorityRules: updated);
    _recomputeCards();
  }

  void _recomputeCards() {
    final weatherState = _ref.read(weatherProvider);
    final alertsState = _ref.read(alertsProvider);

    if (weatherState.currentWeather == null) return;

    final cards = PersonalizationEngine.computePersonalizedCards(
      selectedInterests: state.selectedInterests,
      priorityRules: state.priorityRules,
      weather: weatherState.currentWeather!,
      activeAlerts: alertsState.activeAlerts,
    );

    state = state.copyWith(personalizedCards: cards);
  }
}

final personalizationProvider =
    StateNotifierProvider<PersonalizationNotifier, PersonalizationState>((ref) {
  return PersonalizationNotifier(ref);
});
