// lib/features/authentication/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/otp_request_model.dart';
import '../models/otp_verify_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';

/// Abstract class - Defines what operations the remote data source must have
///
/// Why abstract? So we can create a mock version for testing
/// without making real API calls
abstract class AuthRemoteDataSource {
  Future<UserModel> registerUser(RegisterRequestModel request);
  Future<String> requestOTP(OTPRequestModel request);
  Future<AuthResponseModel> verifyOTP(OTPVerifyModel request);
  Future<UserModel> getCurrentUser();
  Future<UserModel> getUserById(int userId);
}

/// Implementation of remote data source
/// This is the actual class that makes HTTP requests to your Flask API
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;  // HTTP client we created earlier

  /// Constructor - Dependency Injection
  /// We receive the DioClient rather than creating it
  /// This makes testing easier
  AuthRemoteDataSourceImpl(this.dioClient);

  /// Register a new user
  ///
  /// Makes POST request to: http://127.0.0.1:5555/gems/users
  /// Sends: {"username": "...", "email": "...", "phone": "..."}
  /// Receives: {"id": 1, "username": "...", "email": "...", ...}
  @override
  Future<UserModel> registerUser(RegisterRequestModel request) async {
    try {
      print('📤 Registering user: ${request.username}');

      // Make HTTP POST request
      final response = await dioClient.post(
        ApiEndpoints.userRegistration,  // '/users'
        data: request.toJson(),          // Convert model to JSON
      );

      print('📥 Registration response: ${response.data}');

      // Check if request was successful (status code 200-299)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response JSON into UserModel
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        // Unexpected status code
        throw ServerException(
          message: 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Network error, timeout, or HTTP error
      print('❌ Registration error: ${e.message}');
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      // Any other error (parsing, etc.)
      print('❌ Unexpected error: $e');
      throw ServerException(message: 'Unexpected error during registration');
    }
  }

  /// Request OTP to be sent to email
  ///
  /// POST to: http://127.0.0.1:5555/gems/request-otp
  /// Sends: {"email": "john@email.com"}
  /// Receives: {"message": "OTP sent successfully"} or similar
  @override
  Future<String> requestOTP(OTPRequestModel request) async {
    try {
      print('📤 Requesting OTP for: ${request.email}');

      final response = await dioClient.post(
        ApiEndpoints.requestOTP,  // '/request-otp'
        data: request.toJson(),
      );

      print('📥 OTP request response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract success message from response
        final data = response.data;

        if (data is Map<String, dynamic>) {
          // Flask might return: {"message": "OTP sent"}
          return data['message'] as String? ?? 'OTP sent successfully';
        } else if (data is String) {
          return data;
        }

        return 'OTP sent successfully';
      } else {
        throw ServerException(
          message: 'Failed to send OTP',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('❌ OTP request error: ${e.message}');
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw ServerException(message: 'Failed to request OTP');
    }
  }

  /// Verify OTP and get authentication token
  ///
  /// POST to: http://127.0.0.1:5555/gems/verify-otp
  /// Sends: {"email": "john@email.com", "otp": "ABCD12"}
  /// Receives: {
  ///   "access_token": "eyJhbGc...",
  ///   "user": {...},
  ///   "message": "OTP verified"
  /// }
  @override
  // Future<AuthResponseModel> verifyOTP(OTPVerifyModel request) async {
  //   try {
  //     print('📤 Verifying OTP for: ${request.email}');
  //
  //     final response = await dioClient.post(
  //       ApiEndpoints.verifyOTP,  // '/verify-otp'
  //       data: request.toJson(),
  //     );
  //
  //     print('📥 OTP verification response: ${response.data}');
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Parse the authentication response
  //       return AuthResponseModel.fromJson(
  //         response.data as Map<String, dynamic>,
  //       );
  //     } else {
  //       throw ServerException(
  //         message: 'OTP verification failed',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     print('❌ OTP verification error: ${e.message}');
  //
  //     // Special handling for invalid OTP (usually 400 or 401)
  //     if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
  //       throw ServerException(
  //         message: 'Invalid or expired OTP',
  //         statusCode: e.response?.statusCode,
  //       );
  //     }
  //
  //     throw ErrorHandler.handleDioError(e);
  //   } catch (e) {
  //     print('❌ Unexpected error: $e');
  //     throw ServerException(message: 'Failed to verify OTP');
  //   }
  // }

  @override
  Future<AuthResponseModel> verifyOTP(OTPVerifyModel request) async {
    try {
      print('📤 Verifying OTP for: ${request.email}');
      print('📤 OTP Code: ${request.otp}');

      final response = await dioClient.post(
        ApiEndpoints.verifyOTP,  // '/verify-otp'
        data: request.toJson(),
      );

      // ✅ ADD DETAILED LOGGING
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📥 OTP VERIFICATION RESPONSE');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Status Code: ${response.statusCode}');
      print('Response Type: ${response.data.runtimeType}');
      print('Response Data: ${response.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // Check status code
      if (response.statusCode == 200 || response.statusCode == 201) {

        // ✅ SAFE NULL CHECK
        if (response.data == null) {
          print('❌ ERROR: Response data is null!');
          throw ServerException(
            message: 'Server returned empty response',
            statusCode: response.statusCode,
          );
        }

        // ✅ CHECK IF DATA IS A MAP
        if (response.data is! Map<String, dynamic>) {
          print('❌ ERROR: Response is not a JSON object!');
          print('Received type: ${response.data.runtimeType}');
          throw ServerException(
            message: 'Invalid response format from server',
            statusCode: response.statusCode,
          );
        }

        // Parse the authentication response
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );

      } else {
        throw ServerException(
          message: 'OTP verification failed',
          statusCode: response.statusCode,
        );
      }

    } on DioException catch (e) {
      print('❌ DIO ERROR during OTP verification:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');

      // Special handling for invalid OTP (usually 400 or 401)
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {

        // ✅ SAFE ERROR MESSAGE EXTRACTION
        String errorMessage = 'Invalid or expired OTP';

        if (e.response?.data != null) {
          if (e.response!.data is Map) {
            errorMessage = e.response!.data['message'] ??
                e.response!.data['error'] ??
                errorMessage;
          } else if (e.response!.data is String) {
            errorMessage = e.response!.data;
          }
        }

        throw ServerException(
          message: errorMessage,
          statusCode: e.response?.statusCode,
        );
      }

      throw ErrorHandler.handleDioError(e);

    } catch (e, stackTrace) {
      print('❌ UNEXPECTED ERROR during OTP verification: $e');
      print('Stack trace: $stackTrace');
      throw ServerException(message: 'Failed to verify OTP');
    }
  }
  /// Get current authenticated user
  ///
  /// GET to: http://127.0.0.1:5555/gems/whoami
  /// Sends: Authorization: Bearer <token> (automatically added by DioClient)
  /// Receives: {"id": 1, "username": "...", ...}
  @override
  Future<UserModel> getCurrentUser() async {
    try {
      print('📤 Fetching current user');

      final response = await dioClient.get(ApiEndpoints.whoami);

      print('📥 Current user response: ${response.data}');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to get current user',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('❌ Get current user error: ${e.message}');

      // If 401, token is invalid or expired
      if (e.response?.statusCode == 401) {
        throw ServerException(
          message: 'Not authenticated',
          statusCode: 401,
        );
      }

      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw ServerException(message: 'Failed to get current user');
    }
  }

  /// Get user by ID
  ///
  /// GET to: http://127.0.0.1:5555/gems/users/{userId}
  /// Receives: {"id": 1, "username": "...", ...}
  @override
  Future<UserModel> getUserById(int userId) async {
    try {
      print('📤 Fetching user with ID: $userId');

      final response = await dioClient.get(
        '${ApiEndpoints.getUserById}/$userId',  // '/users/1'
      );

      print('📥 User response: ${response.data}');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'User not found',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('❌ Get user error: ${e.message}');

      if (e.response?.statusCode == 404) {
        throw ServerException(
          message: 'User not found',
          statusCode: 404,
        );
      }

      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw ServerException(message: 'Failed to get user');
    }
  }
}