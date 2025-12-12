// lib/core/constants/app_strings.dart
class AppStrings {
  AppStrings._();

  // App
  static const appName = 'Grand Hotel';

  // Authentication
  static const signUp = 'Sign Up';
  static const signIn = 'Sign In'; // ✅ NEW
  static const createAccount = 'Create Account';
  static const letsSignYouIn = "Let's Sign you in"; // ✅ NEW
  static const enterDetails = 'Enter your details to get started';
  static const enterEmailToContinue = 'Lorem ipsum dolor sit amet, consectetur'; // ✅ NEW
  static const username = 'Username';
  static const email = 'Email Address';
  static const phone = 'Phone Number';
  static const password = 'Password'; // ✅ NEW
  static const enterUsername = 'Enter your username';
  static const enterEmail = 'Enter your email';
  static const enterEmailAddress = 'Enter your email address'; // ✅ NEW
  static const enterPassword = 'Enter your password'; // ✅ NEW
  static const enterPhone = 'Enter your phone number';
  static const rememberMe = 'Remember Me'; // ✅ NEW
  static const forgotPassword = 'Forgot Password'; // ✅ NEW
  static const dontHaveAccount = "Don't have an account?"; // ✅ NEW
  static const alreadyHaveAccount = "Already have an account?"; // ✅ NEW
  static const orSignInWith = 'Or Sign In with'; // ✅ NEW

  // OTP
  static const enterOTP = 'Enter OTP';
  static const otpSent = 'We have sent you a 6 digit code to'; // ✅ UPDATED
  static const verifyOTP = 'Verify OTP';
  static const resendCode = 'Resend Code';
  static const didntReceiveCode = "Didn't receive code?";

  // Success
  static const success = 'Success';
  static const accountCreated = 'Your account is created successfully';
  static const continueText = 'Continue';
  static const welcomeBack = 'Welcome back!'; // ✅ NEW

  // Validation
  static const requiredField = 'This field is required';
  static const invalidEmail = 'Please enter a valid email';
  static const invalidPhone = 'Please enter a valid phone number';
  static const usernameTooShort = 'Username must be at least 3 characters';

  // Errors
  static const genericError = 'Something went wrong. Please try again.';
  static const networkError = 'No internet connection';
  static const serverError = 'Server error. Please try again later.';
  static const invalidOTP = 'Invalid OTP. Please try again.';
  static const emailNotFound = 'Email not found. Please register first.'; // ✅ NEW

  // Loading
  static const loading = 'Loading...';
  static const creatingAccount = 'Creating your account...';
  static const verifying = 'Verifying...';
  static const sendingCode = 'Sending verification code...'; // ✅ NEW
}