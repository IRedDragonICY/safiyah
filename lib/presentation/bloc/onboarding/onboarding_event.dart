// presentation/bloc/onboarding/onboarding_event.dart
import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class CheckOnboardingStatus extends OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {}