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
/// Auth Response Model - CORRECTED VERSION
class AuthResponseModel extends AuthResponse {

  // Override the user property to use UserModel specifically
  @override
  final UserModel user;

  const AuthResponseModel({
    required this.user,              // Now explicitly UserModel
    required super.accessToken,
    super.refreshToken,
    super.message,
  }) : super(user: user);            // Pass to parent constructor

  /// Create from JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      // This creates a UserModel
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),

      accessToken: json['access_token'] as String? ??
          json['token'] as String? ??
          '',

      refreshToken: json['refresh_token'] as String?,
      message: json['message'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),  // user is UserModel, so this works
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'message': message,
    };
  }

  /// Convert from entity to model
  factory AuthResponseModel.fromEntity(AuthResponse authResponse) {
    return AuthResponseModel(
      // Convert User entity to UserModel
      user: authResponse.user is UserModel
          ? authResponse.user as UserModel
          : UserModel.fromEntity(authResponse.user),
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      message: authResponse.message,
    );
  }

  /// Convert to entity
  @override
  AuthResponse toEntity() {
    return AuthResponse(
      user: user.toEntity(),  // Convert UserModel to User entity
      accessToken: accessToken,
      refreshToken: refreshToken,
      message: message,
    );
  }
}