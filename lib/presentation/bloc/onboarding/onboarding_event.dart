// presentation/bloc/onboarding/onboarding_event.dart
import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class CheckOnboardingStatus extends OnboardingEvent {
  const CheckOnboardingStatus();
}

class StartOnboarding extends OnboardingEvent {
  const StartOnboarding();
}

class NextPageRequested extends OnboardingEvent {
  const NextPageRequested();
}

class PreviousPageRequested extends OnboardingEvent {
  const PreviousPageRequested();
}

class CompleteOnboardingFlow extends OnboardingEvent {
  const CompleteOnboardingFlow();
}

class CompleteOnboarding extends OnboardingEvent {
  const CompleteOnboarding();
}
