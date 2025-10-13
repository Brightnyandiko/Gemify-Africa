// lib/features/onboarding/presentation/pages/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../../data/models/onboarding_page_model.dart';
import '../widgets/onboarding_page_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      image: 'assets/images/onboarding1.jpg',
      title: 'Discover Your Dream\nHotel, Effortlessly',
      description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding2.jpg',
      title: 'Book with Ease, Stay\nwith Style',
      description: 'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem.',
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding3.jpg',
      title: 'Luxury and Comfort,\nJust a Tap Away',
      description: 'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
  }

  void _onContinue() {
    final currentPage = context.read<OnboardingBloc>().state.currentPage;

    if (currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    context.read<OnboardingBloc>().add(const OnboardingCompleted());
    // Navigate to login/home screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.isCompleted) {
            // Navigation is handled in _completeOnboarding
          }
        },
        child: Stack(
          children: [
            // PageView with onboarding screens
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return OnboardingPageWidget(
                  page: _pages[index],
                  isFirstPage: index == 0,
                );
              },
            ),

            // Bottom content (buttons and indicators)
            Positioned(
              left: 24,
              right: 24,
              bottom: 60,
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Page indicators
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _pages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppColors.primary600,
                          dotColor: Colors.white.withOpacity(0.5),
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 3,
                          spacing: 8,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Continue/Get Started button
                      CustomButton(
                        text: state.currentPage == 0 ? 'Get Started' : 'Continue',
                        onPressed: _onContinue,
                        backgroundColor: AppColors.primary600,
                      ),

                      // Register link (only on first page)
                      if (state.currentPage == 0) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: _navigateToRegister,
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: AppColors.primary400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}