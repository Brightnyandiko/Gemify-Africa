// lib/features/authentication/presentation/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'otp_verification_page.dart';

/// Registration Screen - Sign Up
///
/// Matches Figma Screen 06 (Sign Up)
/// Integrates with Flask backend POST /users endpoint
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up controllers when screen is disposed
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Validate and submit form
  void _onSignUpPressed() {
    // Hide keyboard
    context.hideKeyboard();

    // Validate form
    if (_formKey.currentState?.validate() ?? false) {
      // Get values from controllers
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();

      print('📝 Form validated successfully');
      print('Username: $username');
      print('Email: $email');
      print('Phone: $phone');

      // Dispatch register event to BLoC
      context.read<AuthBloc>().add(
        RegisterUserEvent(
          username: username,
          email: email,
          phone: phone,
        ),
      );
    } else {
      print('❌ Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // BLoC Listener - Listens to state changes and performs actions
      // Like navigation, showing snackbars, etc.
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Update loading state
          setState(() {
            _isLoading = state is AuthLoading;
          });

          // Handle different states
          if (state is RegistrationSuccess) {
            // Registration successful - show success message
            print('✅ Registration successful, waiting for OTP...');
            context.showSnackBar('Registration successful! Sending verification code...');

            // 🔥 FIX: Manually request OTP after registration
            context.read<AuthBloc>().add(
              RequestOTPEvent(email: _emailController.text.trim()),
            );
          }
          else if (state is OTPSent) {
            // OTP sent - navigate to OTP verification screen
            print('📧 OTP sent, navigating to verification screen');
            context.showSnackBar(state.message);

            // Navigate to OTP screen
            context.push(
              OTPVerificationPage(email: state.email),
            );
          }
          else if (state is AuthError) {
            // Error occurred - show error message
            print('❌ Error: ${state.message}');
            context.showSnackBar(state.message, isError: true);
          }
        },

        // Builder - Builds UI based on state
        builder: (context, state) {
          return Stack(
            children: [
              // Main content
              _buildContent(),

              // Loading overlay (shows when loading)
              if (_isLoading)
                const LoadingOverlay(
                  message: 'Creating your account...',
                ),
            ],
          );
        },
      ),
    );
  }

  /// Build main content
  Widget _buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Back button (optional)
              _buildBackButton(),

              const SizedBox(height: 32),

              // Title (matches Figma - "Create Account")
              _buildTitle(),

              const SizedBox(height: 8),

              // Subtitle (matches Figma)
              _buildSubtitle(),

              const SizedBox(height: 40),

              // Username field
              CustomTextField(
                label: 'Username',
                hint: 'Enter your username',
                controller: _usernameController,
                validator: Validators.validateUsername,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
              ),

              const SizedBox(height: 20),

              // Email field
              CustomTextField(
                label: 'Email Address',
                hint: 'Enter your email',
                controller: _emailController,
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
              ),

              const SizedBox(height: 20),

              // Phone field
              CustomTextField(
                label: 'Phone Number',
                hint: 'Enter your phone number',
                controller: _phoneController,
                validator: Validators.validatePhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneNumberFormatter()],
                maxLength: 13,  // Max length for international format
              ),

              const SizedBox(height: 32),

              // Sign Up button
              CustomButton(
                text: 'Sign Up',
                onPressed: _onSignUpPressed,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 24),

              // Terms and conditions text (from Figma)
              _buildTermsText(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

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

  /// Title
  Widget _buildTitle() {
    return Text(
      'Create Account',
      style: AppTextStyles.heading2.copyWith(
        color: AppColors.gray900,
      ),
    );
  }

  /// Subtitle
  Widget _buildSubtitle() {
    return Text(
      'Enter your details to get started',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.gray500,
      ),
    );
  }

  /// Terms and conditions text
  Widget _buildTermsText() {
    return Text.rich(
      TextSpan(
        text: 'By signing up you agree to our ',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.gray600,
        ),
        children: [
          TextSpan(
            text: 'Terms and Conditions',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
//```
//
//**Key Features:**
//
//1. **Form Validation**: Uses `GlobalKey<FormState>` to validate all fields at once
//2. **BlocConsumer**: Listens to state changes AND builds UI
//3. **Navigation**: Automatically navigates to OTP screen when OTP is sent
//4. **Loading Overlay**: Shows when processing registration
//5. **Error Handling**: Shows snackbar with error messages
//6. **Clean Controllers**: Disposed properly to prevent memory leaks
//
//**How it works:**
//```
//User fills form → Presses "Sign Up"
//↓
//Validate form fields
//↓
//Dispatch RegisterUserEvent to BLoC
//↓
//BLoC shows AuthLoading → UI shows loading overlay
//↓
//BLoC calls registerUser use case → Repository → Flask API
//↓
//Flask responds with user data
//↓
//BLoC emits RegistrationSuccess
//↓
//BLoC automatically requests OTP
//↓
//BLoC emits OTPSent
//↓
//UI navigates to OTP Verification screen