// lib/core/utils/validators.dart
class Validators {
  Validators._();

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it's a valid phone format (international or local)
    // Supports formats like: 0712345678, +254712345678, 254712345678
    final phoneRegex = RegExp(r'^(\+?254|0)?[17]\d{8}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 30) {
      return 'Username must be less than 30 characters';
    }

    // Username can contain letters, numbers, underscore, hyphen
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');

    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, - and _';
    }

    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != 6) {
      return 'OTP must be 6 characters';
    }

    // OTP should be alphanumeric
    final otpRegex = RegExp(r'^[A-Z0-9]{6}$');

    if (!otpRegex.hasMatch(value)) {
      return 'Invalid OTP format';
    }

    return null;
  }
}