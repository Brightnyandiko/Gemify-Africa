// lib/features/onboarding/presentation/bloc/onboarding_state.dart
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  final int currentPage;

  const OnboardingInitial({this.currentPage = 0});

  @override
  List<Object> get props => [currentPage];
}

class OnboardingInProgress extends OnboardingState {
  final int currentPage;
  final int totalPages;

  const OnboardingInProgress({
    required this.currentPage,
    required this.totalPages,
  });

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  List<Object> get props => [currentPage, totalPages];
}

class OnboardingFinished extends OnboardingState {
  const OnboardingFinished();
}