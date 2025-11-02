// lib/features/authentication/domain/entities/auth_response_model.dart

import 'package:Gemify/features/authentication/domain/entities/user.dart';

/// Auth Response Entity - What we get back after successful authentication
/// This represents the server's response when authentication succeeds
class AuthResponse {
  final User user;              // The user information
  final String accessToken;     // JWT token for API authentication
  final String? refreshToken;   // Token to get a new access token (optional)
  final String? message;        // Success message from server

  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.message,
  });

  /// Copy with method for immutability
  AuthResponse copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
    String? message,
  }) {
    return AuthResponse(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'AuthResponse(user: $user, hasToken: ${accessToken.isNotEmpty})';
  }
}