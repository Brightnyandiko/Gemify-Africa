// lib/features/authentication/domain/usecases/register_user.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  // ✅ FIXED: Use named parameter for consistency
  const RegisterUser({required this.repository});

  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    return await repository.registerUser(
      username: params.username,
      email: params.email,
      phone: params.phone,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String phone;

  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [username, email, phone];

  String? validate() {
    if (username.isEmpty) return 'Username is required';
    if (email.isEmpty) return 'Email is required';
    if (phone.isEmpty) return 'Phone number is required';
    if (username.length < 3) return 'Username too short';
    if (!email.contains('@')) return 'Invalid email';
    return null;
  }
}