// lib/features/onboarding/presentation/widgets/onboarding_page_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/onboarding_page_model.dart';
import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_text_styles.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel page;
  final bool isFirstPage;

  const OnboardingPageWidget({
    Key? key,
    required this.page,
    this.isFirstPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            page.image,
            fit: BoxFit.cover,
          ),
        ),

        // Dark overlay gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),

        // Content
        Positioned(
          left: 24,
          right: 24,
          bottom: isFirstPage ? 180 : 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                page.title,
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 36,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                page.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}