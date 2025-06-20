// presentation/bloc/onboarding/onboarding_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiyah/core/constants/app_constants.dart';
import 'package:safiyah/core/services/storage_service.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
    on<StartOnboarding>(_onStartOnboarding);
    on<NextPageRequested>(_onNextPageRequested);
    on<PreviousPageRequested>(_onPreviousPageRequested);
    on<CompleteOnboardingFlow>(_onCompleteOnboardingFlow);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final bool? isCompleted = StorageService.getSetting<bool>(AppConstants.onboardingCompletedKey);

      if (isCompleted == true) {
        emit(const OnboardingCompleted());
      } else {
        emit(const OnboardingInProgress(currentPage: 0));
      }
    } catch (e) {
      emit(const OnboardingInProgress(currentPage: 0));
    }
  }

  void _onStartOnboarding(
    StartOnboarding event,
    Emitter<OnboardingState> emit,
  ) {
    emit(const OnboardingInProgress(currentPage: 0));
  }

  void _onNextPageRequested(
    NextPageRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      final nextPage = currentState.currentPage + 1;
      emit(OnboardingInProgress(currentPage: nextPage));
    }
  }

  void _onPreviousPageRequested(
    PreviousPageRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      if (currentState.currentPage > 0) {
        final prevPage = currentState.currentPage - 1;
        emit(OnboardingInProgress(currentPage: prevPage));
      }
    }
  }

  Future<void> _onCompleteOnboardingFlow(
    CompleteOnboardingFlow event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await StorageService.saveSetting(AppConstants.onboardingCompletedKey, true);
      emit(const OnboardingCompleted());
    } catch (e) {
      emit(const OnboardingCompleted());
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await StorageService.saveSetting(AppConstants.onboardingCompletedKey, true);
      emit(const OnboardingCompleted());
    } catch (e) {
      emit(const OnboardingCompleted());
    }
  }
}
