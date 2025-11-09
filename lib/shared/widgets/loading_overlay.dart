// lib/shared/widgets/loading_overlay.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Loading Overlay - Shows loading spinner with message
///
/// This widget creates a semi-transparent overlay that covers the entire screen
/// with a loading spinner and optional message.
///
/// Usage:
/// ```dart
/// if (isLoading)
///   LoadingOverlay(message: 'Please wait...')
/// ```
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? spinnerColor;

  const LoadingOverlay({
    Key? key,
    this.message,
    this.backgroundColor,
    this.spinnerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Cover entire screen
      width: double.infinity,
      height: double.infinity,

      // Semi-transparent dark background
      color: backgroundColor ?? Colors.black.withOpacity(0.5),

      // Center the loading indicator
      child: Center(
        child: Container(
          // White card containing spinner and message
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            color: AppColors.gray0,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Loading spinner
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  spinnerColor ?? AppColors.primary600,
                ),
                strokeWidth: 3,
              ),

              // Message (if provided)
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}