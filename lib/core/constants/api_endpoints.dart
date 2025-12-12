// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'http://34.170.7.252/gems';

  // Auth Endpoints
  static const String userRegistration = '/users';
  static const String requestOTP = '/request-otp';
  static const String verifyOTP = '/verify-otp';
  static const String getUserById = '/users';  // /users/{id}
  static const String whoami = '/whoami';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}