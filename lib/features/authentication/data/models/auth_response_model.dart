// lib/features/authentication/data/models/auth_response_model.dart

import '../../domain/entities/auth_response.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthResponse {
  @override
  final UserModel user;

  const AuthResponseModel({
    required this.user,
    required super.accessToken,
    super.refreshToken,
    super.message,
  }) : super(user: user);

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing AuthResponseModel from JSON...');
    print('JSON Keys: ${json.keys.toList()}');

    try {
      // Extract access token
      String? accessToken = json['access_token'] as String? ??
          json['token'] as String?;

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Missing access_token in API response');
      }

      print('✅ Found access token');

      // Handle both nested and flat user data formats
      UserModel user;

      if (json.containsKey('user') && json['user'] != null) {
        // Nested format: { "user": { "id": 1, ... } }
        print('📦 Found nested user object');
        final userData = json['user'] as Map<String, dynamic>;
        user = UserModel.fromJson(userData);
      }
      else if (json.containsKey('id') && json.containsKey('username')) {
        // Flat format: { "id": 1, "username": "...", ... }
        print('📦 Found flat user data at top level');
        user = UserModel.fromJson({
          'id': json['id'],
          'username': json['username'],
          'email': json['email'],
          'phone': json['phone'],
          'created_at': json['created_at'],
          'updated_at': json['updated_at'],
        });
      }
      else {
        throw Exception('No user data found in response');
      }

      print('✅ Successfully created UserModel: ${user.username}');

      return AuthResponseModel(
        user: user,
        accessToken: accessToken,
        refreshToken: json['refresh_token'] as String?,
        message: json['message'] as String?,
      );

    } catch (e, stackTrace) {
      print('❌ ERROR parsing AuthResponseModel: $e');
      print('Stack trace: $stackTrace');
      print('JSON received: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'message': message,
    };
  }

  factory AuthResponseModel.fromEntity(AuthResponse authResponse) {
    return AuthResponseModel(
      user: authResponse.user is UserModel
          ? authResponse.user as UserModel
          : UserModel.fromEntity(authResponse.user),
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      message: authResponse.message,
    );
  }

  @override
  AuthResponse toEntity() {
    return AuthResponse(
      user: user.toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
      message: message,
    );
  }
}