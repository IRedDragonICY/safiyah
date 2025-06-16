// presentation/bloc/onboarding/onboarding_state.dart
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingShow extends OnboardingState {}

class OnboardingCompleted extends OnboardingState {}