// lib/features/authentication/domain/usecases/register_user.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Register a new user
///
/// This represents the business action of creating a new account.
/// It validates the input and delegates to the repository.
class RegisterUser {
  final AuthRepository repository;  // Dependency on the repository interface

  /// Constructor - We inject the repository
  /// This is "Dependency Injection" - the use case receives what it needs
  /// rather than creating it itself
  RegisterUser(this.repository);

  /// Call method - Makes the class callable like a function
  /// Usage: registerUser(params) instead of registerUser.execute(params)
  ///
  /// This is a common pattern in Clean Architecture
  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    // Input validation could go here
    // For now, we delegate directly to the repository

    return await repository.registerUser(
      username: params.username,
      email: params.email,
      phone: params.phone,
    );
  }
}

/// Parameters for RegisterUser use case
///
/// Why a separate class?
/// 1. Type safety - can't pass wrong parameters
/// 2. Easy to add validation
/// 3. Clear documentation of what's needed
/// 4. Easier to test
class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String phone;

  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.phone,
  });

  /// Equatable props - Used for comparison
  /// Two params are equal if all fields match
  @override
  List<Object?> get props => [username, email, phone];

  /// Validation method - Check if parameters are valid
  /// Returns error message if invalid, null if valid
  String? validate() {
    if (username.isEmpty) return 'Username is required';
    if (email.isEmpty) return 'Email is required';
    if (phone.isEmpty) return 'Phone number is required';

    if (username.length < 3) return 'Username too short';
    if (!email.contains('@')) return 'Invalid email';

    return null; // All valid!
  }

  @override
  String toString() => 'RegisterUserParams(username: $username, email: $email)';
}