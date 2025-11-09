// lib/features/authentication/presentation/widgets/custom_text_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Custom Text Field - Matches Figma design
///
/// Features:
/// - Label above field
/// - Placeholder text
/// - Validation support
/// - Custom keyboard types
/// - Optional formatters (like phone number formatting)
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (like "Full Name" in Figma)
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        // Text field
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          enabled: enabled,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray800,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray400,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,

            // Remove character counter if maxLength is set
            counterText: '',

            // Border styling (matches Figma - light gray border)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.gray300,
                width: 1,
              ),
            ),

            // When field is not focused
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.gray300,
                width: 1,
              ),
            ),

            // When field is focused (matches Figma - blue border)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primary600,
                width: 2,
              ),
            ),

            // When field has error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),

            // When field is focused and has error
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),

            // When field is disabled
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.gray200,
                width: 1,
              ),
            ),

            // Padding inside the field
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            // Background color when disabled
            filled: !enabled,
            fillColor: AppColors.gray50,
          ),
        ),
      ],
    );
  }
}