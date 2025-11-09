// lib/features/onboarding/presentation/bloc/onboarding_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const int totalPages = 3;

  OnboardingBloc({required Object sharedPreferences, required int totalPages}) : super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompleted>(_onCompleted);
    on<OnboardingSkipped>(_onSkipped);
  }

  void _onPageChanged(
      OnboardingPageChanged event,
      Emitter<OnboardingState> emit,
      ) {
    emit(state.copyWith(
      currentPage: event.pageIndex,
      isLastPage: event.pageIndex == totalPages - 1,
    ));
  }

  void _onCompleted(
      OnboardingCompleted event,
      Emitter<OnboardingState> emit,
      ) {
    emit(state.copyWith(isCompleted: true));
  }

  void _onSkipped(
      OnboardingSkipped event,
      Emitter<OnboardingState> emit,
      ) {
    emit(state.copyWith(isCompleted: true));
  }
}