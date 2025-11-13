// lib/features/authentication/domain/usecases/register_user.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Register a new user
///
/// This represents the business action of creating a new account.
/// It validates the input and delegates to the repository.
class RegisterUser {
  final AuthRepository repository;
  final NetworkInfo networkInfo; // ✅ Optional: Check at use case level too

  RegisterUser({
    required this.repository,
    required this.networkInfo,
  });

  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    // Optional: Quick connectivity check before even calling repository
    // This provides faster feedback to user
    print('🔍 [UseCase] Quick connectivity pre-check...');

    final hasConnection = await networkInfo.isConnected;

    if (!hasConnection) {
      print('❌ [UseCase] No network connection - failing fast');
      return const Left(NetworkFailure(
        'No internet connection',
      ));
    }

    print('✅ [UseCase] Connectivity confirmed, proceeding...');

    // Delegate to repository for actual work
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