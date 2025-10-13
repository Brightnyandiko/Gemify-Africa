// lib/features/onboarding/presentation/bloc/onboarding_state.dart

import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isLastPage;
  final bool isCompleted;

  const OnboardingState({
    this.currentPage = 0,
    this.isLastPage = false,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isLastPage,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentPage, isLastPage, isCompleted];
}