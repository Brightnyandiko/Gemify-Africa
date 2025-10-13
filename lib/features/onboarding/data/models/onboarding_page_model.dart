// lib/features/onboarding/data/models/onboarding_page_model.dart

import 'package:equatable/equatable.dart';

class OnboardingPageModel extends Equatable {
  final String image;
  final String title;
  final String description;

  const OnboardingPageModel({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [image, title, description];
}