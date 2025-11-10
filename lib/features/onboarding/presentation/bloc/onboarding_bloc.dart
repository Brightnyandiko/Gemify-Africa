// lib/features/onboarding/presentation/bloc/onboarding_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int totalPages;
  final SharedPreferences sharedPreferences;

  OnboardingBloc({
    required this.totalPages,
    required this.sharedPreferences,
  }) : super(OnboardingInProgress(currentPage: 0, totalPages: totalPages)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompleted>(_onCompleted);
    on<OnboardingSkipped>(_onSkipped);
  }

  void _onPageChanged(
      OnboardingPageChanged event,
      Emitter<OnboardingState> emit,
      ) {
    emit(OnboardingInProgress(
      currentPage: event.pageIndex,
      totalPages: totalPages,
    ));
  }

  Future<void> _onCompleted(
      OnboardingCompleted event,
      Emitter<OnboardingState> emit,
      ) async {
    await sharedPreferences.setBool('onboarding_completed', true);
    emit(const OnboardingFinished());
  }

  Future<void> _onSkipped(
      OnboardingSkipped event,
      Emitter<OnboardingState> emit,
      ) async {
    await sharedPreferences.setBool('onboarding_completed', true);
    emit(const OnboardingFinished());
  }
}