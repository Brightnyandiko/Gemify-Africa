// lib/features/onboarding/presentation/bloc/onboarding_event.dart

import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}


class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}