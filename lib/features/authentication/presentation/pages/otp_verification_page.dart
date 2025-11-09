// lib/features/authentication/presentation/pages/otp_verification_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/otp_input_field.dart';
import 'success_page.dart';

/// OTP Verification Page
///
/// Matches Figma Screen 07 (Enter OTP)
/// User enters 6-digit OTP received via email
/// Integrates with Flask backend POST /verify-otp endpoint
class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  // OTP controller
  final _otpController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Resend timer
  Timer? _resendTimer;
  int _resendCountdown = 60; // 60 seconds
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  /// Start countdown timer for resend button
  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  /// Handle OTP submission
  void _onVerifyPressed(String otp) {
    print('🔐 Verifying OTP: $otp');

    // Dispatch verify OTP event
    context.read<AuthBloc>().add(
      VerifyOTPEvent(
        email: widget.email,
        otp: otp,
      ),
    );
  }

  /// Handle resend OTP
  void _onResendPressed() {
    if (!_canResend) return;

    print('📧 Resending OTP to ${widget.email}');

    // Dispatch request OTP event
    context.read<AuthBloc>().add(
      RequestOTPEvent(email: widget.email),
    );

    // Restart timer
    _startResendTimer();

    // Show feedback
    context.showSnackBar('Verification code sent!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // Listen to state changes
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Update loading state
          setState(() {
            _isLoading = state is AuthLoading;
          });

          // Handle different states
          if (state is OTPVerified) {
            // OTP verified successfully!
            print('✅ OTP verified, user authenticated!');
            context.showSnackBar('Verification successful!');

            // Navigate to success screen
            context.pushReplacement(
              SuccessPage(user: state.user),
            );
          }
          else if (state is AuthError) {
            // Error occurred
            print('❌ Verification error: ${state.message}');
            context.showSnackBar(state.message, isError: true);

            // Clear OTP input on error
            _otpController.clear();
          }
        },

        // Build UI based on state
        builder: (context, state) {
          return Stack(
            children: [
              // Main content
              _buildContent(),

              // Loading overlay
              if (_isLoading)
                const LoadingOverlay(
                  message: 'Verifying code...',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Back button
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios),
                color: AppColors.gray800,
              ),
            ),

            const SizedBox(height: 40),

            // Illustration (optional - you can add an SVG icon here)
            _buildIllustration(),

            const SizedBox(height: 32),

            // Title
            _buildTitle(),

            const SizedBox(height: 12),

            // Description
            _buildDescription(),

            const SizedBox(height: 48),

            // OTP Input Field (6 boxes)
            OTPInputField(
              controller: _otpController,
              onCompleted: _onVerifyPressed,
              onChanged: (value) {
                print('OTP entered: $value');
              },
              enabled: !_isLoading,
            ),

            const SizedBox(height: 32),

            // Verify button
            CustomButton(
              text: 'Verify OTP',
              onPressed: () {
                final otp = _otpController.text;
                if (otp.length == 6) {
                  _onVerifyPressed(otp);
                } else {
                  context.showSnackBar(
                    'Please enter 6-digit OTP',
                    isError: true,
                  );
                }
              },
              isLoading: _isLoading,
            ),

            const SizedBox(height: 24),

            // Resend code
            _buildResendSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Illustration
  Widget _buildIllustration() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primary500,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.email_outlined,
        size: 60,
        color: AppColors.primary600,
      ),
    );
  }

  /// Title
  Widget _buildTitle() {
    return Text(
      'Enter OTP',
      style: AppTextStyles.heading2.copyWith(
        color: AppColors.gray900,
      ),
    );
  }

  /// Description with email
  Widget _buildDescription() {
    return Text.rich(
      TextSpan(
        text: 'We have sent you a 6 digit code to\n',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.gray600,
        ),
        children: [
          TextSpan(
            text: widget.email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Resend section with countdown timer
  Widget _buildResendSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive code? ",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
          ),
        ),
        GestureDetector(
          onTap: _canResend ? _onResendPressed : null,
          child: Text(
            _canResend
                ? 'Resend Code'
                : 'Resend in ${_resendCountdown}s',
            style: AppTextStyles.bodySmall.copyWith(
              color: _canResend
                  ? AppColors.primary600
                  : AppColors.gray400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}