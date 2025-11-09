// lib/features/authentication/presentation/widgets/custom_button.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Custom Button - Matches Figma design
///
/// Features:
/// - Full width by default
/// - Loading state support
/// - Disabled state support
/// - Custom colors
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final Widget? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if button should be disabled
    final bool disabled = !isEnabled || isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,  // Full width by default
      height: height,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // Button color (matches Figma primary blue)
          backgroundColor: backgroundColor ?? AppColors.primary600,

          // Text color
          foregroundColor: textColor ?? AppColors.gray0,

          // Disabled color (lighter blue)
          disabledBackgroundColor: AppColors.primary300,
          disabledForegroundColor: AppColors.gray0.withOpacity(0.7),

          // Remove elevation/shadow
          elevation: 0,

          // Corner radius (8px from Figma)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),

          // Padding
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
        child: isLoading
            ? _buildLoadingIndicator()
            : _buildButtonContent(),
      ),
    );
  }

  /// Loading spinner
  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          textColor ?? AppColors.gray0,
        ),
      ),
    );
  }

  /// Button content (text with optional icon)
  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bigButton.copyWith(
              color: textColor,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.bigButton.copyWith(
        color: textColor,
      ),
    );
  }
}