// lib/features/authentication/presentation/pages/otp_verification_page.dart

import 'package:flutter/material.dart';

/// OTP Verification Page - Placeholder
///
/// This is a temporary placeholder. We'll implement the full version next.
class OTPVerificationPage extends StatelessWidget {
  final String email;

  const OTPVerificationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('OTP Verification'),
            const SizedBox(height: 16),
            Text('Email: $email'),
            const SizedBox(height: 16),
            const Text('Full implementation coming next...'),
          ],
        ),
      ),
    );
  }
}