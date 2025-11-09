// lib/features/authentication/presentation/widgets/otp_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// OTP Input Field - 6 individual boxes for OTP entry
///
/// Uses the Pinput package for beautiful OTP input
/// Matches your Flask backend (6-character OTP like "YTLZRV")
class OTPInputField extends StatelessWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final bool enabled;

  const OTPInputField({
    Key? key,
    required this.onCompleted,
    this.onChanged,
    this.controller,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the appearance of OTP boxes
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: AppTextStyles.heading3.copyWith(
        color: AppColors.gray800,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray0,
        border: Border.all(
          color: AppColors.gray300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    // When box is focused (blue border - from Figma)
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: AppColors.primary600,
          width: 2,
        ),
      ),
    );

    // When box has value (filled)
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.primary500,
        border: Border.all(
          color: AppColors.primary600,
          width: 1,
        ),
      ),
    );

    // Error state
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: AppColors.error,
          width: 1,
        ),
      ),
    );

    return Pinput(
      controller: controller,
      length: 6,  // 6 characters (matches your backend)
      enabled: enabled,

      // Auto focus first box
      autofocus: true,

      // Show cursor
      showCursor: true,

      // Cursor properties
      cursor: Container(
        width: 2,
        height: 24,
        color: AppColors.primary600,
      ),

      // Only allow uppercase letters and numbers (OTP format)
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
        UpperCaseTextFormatter(),
      ],

      // Keyboard type
      keyboardType: TextInputType.text,

      // Text capitalization
      textCapitalization: TextCapitalization.characters,

      // Themes
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,

      // Callbacks
      onChanged: onChanged,
      onCompleted: onCompleted,

      // Paste support
      enableSuggestions: true,

      // Haptic feedback when entering each digit
      hapticFeedbackType: HapticFeedbackType.lightImpact,
    );
  }
}

/// Uppercase text formatter
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}