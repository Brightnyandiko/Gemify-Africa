// lib/features/authentication/data/models/auth_response_model.dart

import '../../domain/entities/auth_response.dart';
import 'user_model.dart';

/// Auth Response Model - What we get back after successful OTP verification
///
/// Your Flask API returns something like:
/// {
///   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
///   "user": {
///     "id": 1,
///     "username": "john_doe",
///     "email": "john@email.com",
///     "phone": "254712345678"
///   },
///   "message": "OTP verified successfully"
/// }
class AuthResponseModel extends AuthResponse {

  const AuthResponseModel({
    required super.user,
    required super.accessToken,
    super.refreshToken,
    super.message,
  });

  /// Create from JSON - Parses the Flask API response
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      // Parse the nested user object
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),

      // Get the JWT token
      accessToken: json['access_token'] as String? ??
          json['token'] as String? ?? // Alternative field name
          '',

      // Optional refresh token (your API might not provide this)
      refreshToken: json['refresh_token'] as String?,

      // Success message from server
      message: json['message'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'message': message,
    };
  }

  /// Convert from entity to model
  factory AuthResponseModel.fromEntity(AuthResponse authResponse) {
    return AuthResponseModel(
      user: authResponse.user,
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      message: authResponse.message,
    );
  }

  /// Convert to entity
  @override
  AuthResponse toEntity() {
    return AuthResponse(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
      message: message,
    );
  }
}