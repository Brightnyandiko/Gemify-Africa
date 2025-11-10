// lib/features/onboarding/presentation/pages/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
// import '../../data/datasources/onboarding_data.dart';
import '../../data/datasources/onboarding_data.dart';
import '../../data/models/onboarding_page_model.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<OnboardingPageModel> _pages = OnboardingData.getPages();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToAuth() {
    // Navigate to authentication screens
    // For now, just print
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingFinished) {
          _navigateToAuth();
        }
      },
      child: Scaffold(
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is! OnboardingInProgress) {
              return const SizedBox.shrink();
            }

            return Stack(
              children: [
                // PageView
                PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    context.read<OnboardingBloc>().add(
                      OnboardingPageChanged(index),
                    );
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(page: _pages[index]);
                  },
                ),

                // Bottom Content (Button, Indicator, Skip)
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 60,
                  child: Column(
                    children: [
                      // Page Indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _pages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppColors.primary600,
                          dotColor: Colors.white.withOpacity(0.3),
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 3,
                          spacing: 6,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Button
                      CustomButton(
                        text: state.isLastPage ? 'Continue' :
                        state.currentPage == 0 ? 'Get Started' : 'Continue',
                        onPressed: () {
                          if (state.isLastPage) {
                            context.read<OnboardingBloc>().add(
                              const OnboardingCompleted(),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),

                      // Register Link (only on last page)
                      if (state.currentPage == 2) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 14,
                                color: AppColors.gray0
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<OnboardingBloc>().add(
                                  const OnboardingSkipped(),
                                );
                              },
                              child: Text(
                                'Register',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 14,
                                  color: AppColors.primary600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}