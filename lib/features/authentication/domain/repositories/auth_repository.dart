// lib/features/authentication/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';  // Either type for error handling
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/auth_response.dart';

/// Abstract class = Interface in Dart
/// This defines WHAT operations are possible, not HOW they work
///
/// Why "abstract"? Because we can't create instances of this class directly.
/// It only exists to define the contract.
abstract class AuthRepository {

  /// Register a new user
  ///
  /// Parameters:
  /// - username: The user's chosen username
  /// - email: The user's email address
  /// - phone: The user's phone number
  ///
  /// Returns: Either<Failure, User>
  /// - Left side (Failure) = Something went wrong
  /// - Right side (User) = Success! Here's the user
  ///
  /// This is called "Railway Oriented Programming" - the result can go
  /// down two different tracks: success or failure
  Future<Either<Failure, User>> registerUser({
    required String username,
    required String email,
    required String phone,
  });

  /// Request OTP to be sent to user's email
  ///
  /// Parameters:
  /// - email: Where to send the OTP
  ///
  /// Returns: Either<Failure, String>
  /// - Left (Failure) = Couldn't send OTP
  /// - Right (String) = Success! OTP sent, here's a confirmation message
  Future<Either<Failure, String>> requestOTP({
    required String email,
  });

  /// Verify the OTP code the user entered
  ///
  /// Parameters:
  /// - email: User's email
  /// - otp: The 6-character code they received
  ///
  /// Returns: Either<Failure, AuthResponse>
  /// - Left (Failure) = Wrong OTP or expired
  /// - Right (AuthResponse) = Correct! Here's the user and JWT token
  Future<Either<Failure, AuthResponse>> verifyOTP({
    required String email,
    required String otp,
  });

  /// Get the currently logged-in user
  ///
  /// Returns: Either<Failure, User>
  /// - Left (Failure) = Not logged in or token expired
  /// - Right (User) = Here's who's logged in
  Future<Either<Failure, User>> getCurrentUser();

  /// Get a specific user by their ID
  ///
  /// Parameters:
  /// - userId: The user's unique identifier
  ///
  /// Returns: Either<Failure, User>
  Future<Either<Failure, User>> getUserById(int userId);

  /// Log out the current user
  ///
  /// Returns: Either<Failure, void>
  /// - Left (Failure) = Logout failed
  /// - Right (void) = Successfully logged out
  Future<Either<Failure, void>> logout();

  /// Check if a user is currently authenticated
  ///
  /// Returns: Either<Failure, bool>
  /// - Right (true) = User is logged in with valid token
  /// - Right (false) = No user logged in
  Future<Either<Failure, bool>> isAuthenticated();
}