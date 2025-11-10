// lib/features/onboarding/data/datasources/onboarding_data.dart
import '../models/onboarding_page_model.dart';

class OnboardingData {
  static List<OnboardingPageModel> getPages() {
    return [
      const OnboardingPageModel(
        image: 'assets/images/onboarding1.png',
        title: 'Discover Your Dream\nHotel, Effortlessly',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        isLastPage: false,
      ),
      const OnboardingPageModel(
        image: 'assets/images/onboarding2.png',
        title: 'Book with Ease, Stay\nwith Style',
        description: 'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem.',
        isLastPage: false,
      ),
      const OnboardingPageModel(
        image: 'assets/images/onboarding3.png',
        title: 'Luxury and Comfort,\nJust a Tap Away',
        description: 'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem.',
        isLastPage: true,
      ),
    ];
  }
}
