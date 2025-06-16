// presentation/bloc/onboarding/onboarding_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiyah/core/constants/app_constants.dart';
import 'package:safiyah/core/services/storage_service.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final bool? isCompleted = StorageService.getSetting<bool>(AppConstants.onboardingCompletedKey);

      if (isCompleted == true) {
        emit(OnboardingCompleted());
      } else {
        emit(OnboardingShow());
      }
    } catch (e) {
      emit(OnboardingShow());
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await StorageService.saveSetting(AppConstants.onboardingCompletedKey, true);
      emit(OnboardingCompleted());
    } catch (e) {
      //
    }
  }
}