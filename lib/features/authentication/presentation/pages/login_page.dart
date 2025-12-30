// lib/features/authentication/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'otp_verification_page.dart';
import 'register_page.dart';

/// Login Screen
///
/// This is the first screen users see after onboarding.
/// It matches the Figma design with email input and Sign In button.
///
/// Flow: User enters email → Clicks Sign In → Receives OTP → Verifies OTP
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ============================================================================
  // STEP 2.1: Form Controllers and State Variables
  // ============================================================================

  /// Form key - This validates all input fields at once
  /// Think of it as a "quality checker" for your form
  final _formKey = GlobalKey<FormState>();

  /// Email controller - Manages what the user types in the email field
  /// Like a notebook that remembers what was written
  final _emailController = TextEditingController();

  /// Loading state - Shows/hides the loading spinner
  bool _isLoading = false;

  /// Navigation guard - Prevents navigating twice to the same screen
  /// Like a bouncer at a club - "You already went in, no re-entry!"
  bool _hasNavigated = false;

  /// Remember Me checkbox state
  bool _rememberMe = false;

  // ============================================================================
  // STEP 2.2: Cleanup Method
  // ============================================================================

  /// dispose() is called when this screen is removed from memory
  /// We clean up controllers to prevent memory leaks
  /// Think of it as turning off lights when leaving a room
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ============================================================================
  // STEP 2.3: Handle Sign In Button Press
  // ============================================================================

  /// This runs when user presses "Sign In" button
  void _onSignInPressed() {
    // Hide keyboard (like closing a laptop lid)
    context.hideKeyboard();

    // Validate the form (check if email is valid)
    if (_formKey.currentState?.validate() ?? false) {
      // Get the email user typed
      final email = _emailController.text.trim();

      print('📧 Email validated: $email');
      print('🔄 Requesting OTP...');

      // Tell the BLoC to request an OTP
      // BLoC = "Business Logic Component" - the brain of your app
      context.read<AuthBloc>().add(
        RequestOTPEvent(email: email),
      );
    } else {
      print('❌ Form validation failed');
    }
  }

  // ============================================================================
  // STEP 2.4: Navigate to Register Screen
  // ============================================================================

  /// When user clicks "Sign Up" link
  void _onSignUpPressed() {
    print('➡️  Navigating to Register screen');
    context.push(const RegisterPage());
  }

  // ============================================================================
  // STEP 2.5: Social Login Placeholders
  // ============================================================================

  /// These are placeholder methods for Google/Apple/Facebook login
  /// You'll implement actual OAuth logic later
  void _onGoogleSignIn() {
    print('🔵 Google Sign In pressed');
    context.showSnackBar('Google Sign In - Coming soon!');
  }

  void _onAppleSignIn() {
    print('🍎 Apple Sign In pressed');
    context.showSnackBar('Apple Sign In - Coming soon!');
  }

  void _onFacebookSignIn() {
    print('📘 Facebook Sign In pressed');
    context.showSnackBar('Facebook Sign In - Coming soon!');
  }

  // ============================================================================
  // STEP 2.6: Build the UI
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// BlocConsumer listens to state changes AND builds UI
      /// Like a radio that both receives signals AND plays music
      body: BlocConsumer<AuthBloc, AuthState>(

        /// listenWhen - Controls WHEN to listen to state changes
        /// Only listen if we haven't navigated yet (prevents duplicate navigation)
        listenWhen: (previous, current) {
          print('🔍 listenWhen - _hasNavigated: $_hasNavigated');
          return !_hasNavigated;
        },

        /// listener - Reacts to state changes (like navigation, showing messages)
        listener: (context, state) {
          // Update loading state
          setState(() {
            _isLoading = state is AuthLoading;
          });

          print('👂 Listener fired - State: $state');

          // Handle different states
          if (state is OTPSent) {
            // OTP was sent successfully!
            print('✅ OTP sent to ${state.email}');
            context.showSnackBar(state.message);

            // Set navigation guard
            _hasNavigated = true;

            // Navigate to OTP verification screen
            context.push(
              OTPVerificationPage(email: state.email),
            ).then((_) {
              // Reset flag when user comes back
              setState(() {
                _hasNavigated = false;
              });
            });
          }
          else if (state is AuthError) {
            // Something went wrong
            print('❌ Error: ${state.message}');
            context.showSnackBar(state.message, isError: true);
          }
        },

        /// builder - Builds the UI based on current state
        builder: (context, state) {
          return Stack(
            children: [
              // Main content
              _buildContent(),

              // Loading overlay (shows when _isLoading = true)
              if (_isLoading)
                const LoadingOverlay(
                  message: 'Sending verification code...',
                ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================================
  // STEP 2.7: Build Main Content
  // ============================================================================

  Widget _buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button
              // _buildBackButton(),

              const SizedBox(height: 40),

              // Title: "Let's Sign you in"
              _buildTitle(),

              const SizedBox(height: 8),

              // Subtitle
              _buildSubtitle(),

              const SizedBox(height: 40),

              // Email field
              CustomTextField(
                label: 'Email Address',
                hint: 'Enter your email address',
                controller: _emailController,
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
              ),

              const SizedBox(height: 32),

              // Sign In button
              CustomButton(
                text: 'Sign In',
                onPressed: _onSignInPressed,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 24),

              // "Don't have an account? Sign Up"
              _buildSignUpLink(),

              const SizedBox(height: 10),

              // "Or Sign In with"
              // _buildDividerText(),

              // const SizedBox(height: 24),

              // Social login buttons
              // _buildSocialButtons(),

              // const SizedBox(height: 32),

              // Terms and conditions
              _buildTermsText(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // STEP 2.8: Individual Widget Builders
  // ============================================================================

  /// Back button
  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => context.pop(),
      icon: const Icon(Icons.arrow_back_ios),
      color: AppColors.gray800,
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
    );
  }

  /// Title: "Let's Sign you in"
  Widget _buildTitle() {
    return Text(
      "Let's Sign you in",
      style: AppTextStyles.heading2.copyWith(
        color: AppColors.gray900,
      ),
    );
  }

  /// Subtitle
  Widget _buildSubtitle() {
    return Text(
      'Access the services of the app by signing in.',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.gray500,
      ),
    );
  }

  /// "Don't have an account? Sign Up" link
  Widget _buildSignUpLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray600,
            ),
          ),
          GestureDetector(
            onTap: _onSignUpPressed,
            child: Text(
              'Sign Up',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// "Or Sign In with" divider
  Widget _buildDividerText() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.gray300,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or Sign In with',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.gray300,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  /// Social login buttons (Google, Apple, Facebook)
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google button
        _buildSocialButton(
          icon: '🔵', // Use actual Google icon in production
          onTap: _onGoogleSignIn,
        ),

        const SizedBox(width: 16),

        // Apple button
        _buildSocialButton(
          icon: '🍎', // Use actual Apple icon
          onTap: _onAppleSignIn,
        ),

        const SizedBox(width: 16),

        // Facebook button
        _buildSocialButton(
          icon: '📘', // Use actual Facebook icon
          onTap: _onFacebookSignIn,
        ),
      ],
    );
  }

  /// Individual social button
  Widget _buildSocialButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gray200,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  /// Terms and conditions text
  Widget _buildTermsText() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'By signing in you agree to our ',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
          ),
          children: [
            TextSpan(
              text: 'Terms and Conditions of Use',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}