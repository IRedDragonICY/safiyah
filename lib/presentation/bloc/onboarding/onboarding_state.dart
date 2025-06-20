// presentation/bloc/onboarding/onboarding_state.dart
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingInProgress extends OnboardingState {
  final int currentPage;

  const OnboardingInProgress({required this.currentPage});

  OnboardingInProgress copyWith({int? currentPage}) {
    return OnboardingInProgress(
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [currentPage];
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}
