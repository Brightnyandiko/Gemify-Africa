// lib/features/authentication/presentation/pages/success_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../widgets/custom_button.dart';

/// Success Screen
///
/// Matches Figma Screen 11 (Success)
/// Shows after successful OTP verification
class SuccessPage extends StatelessWidget {
  final User user;

  const SuccessPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon (green checkmark in circle)
              _buildSuccessIcon(),

              const SizedBox(height: 32),

              // Title
              Text(
                'Success',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.gray900,
                ),
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                'Your account is created successfully',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Continue button
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  // Acknowledge success and transition to authenticated state
                  context.read<AuthBloc>().add(
                    const AuthSuccessAcknowledgedEvent(),
                  );

                  // Pop all registration screens and go to main app
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Success icon - Green checkmark in circle
  Widget _buildSuccessIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle,
        size: 80,
        color: AppColors.success,
      ),
    );
  }
}
//```
//
//---
//
//## Summary of What We Fixed
//
//### The Problem:
//```
//RegisterPage tried to use AuthBloc
//↓
//Flutter looked for BlocProvider<AuthBloc> above RegisterPage
//↓
//Couldn't find it ❌
//↓
//ProviderNotFoundException thrown!
//```
//
//### The Solution:
//```
//1. Created Dependency Injection container (injection_container.dart)
//2. Initialized all dependencies in main()
//3. Provided AuthBloc at app root in main.dart
//4. Now RegisterPage can access AuthBloc ✅
//```
//
//### Complete Flow Now:
//```
//App Starts
//↓
//Dependencies initialized
//↓
//AuthBloc provided at root
//↓
//RegisterPage (can use AuthBloc ✅)
//↓
//User fills form → Submits
//↓
//OTP sent → Navigate to OTP screen
//↓
//User enters OTP → Verifies
//↓
//Success screen shown
//↓
//Navigate to main app (authenticated!)