// lib/features/authentication/domain/usecases/request_otp.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Request OTP
///
/// Business action: Send a verification code to user's email
/// This is part of passwordless authentication flow
class RequestOTP {
  final AuthRepository repository;

  RequestOTP(this.repository);

  /// Execute the use case
  /// Returns a success message if OTP was sent
  Future<Either<Failure, String>> call(RequestOTPParams params) async {
    // Could add rate limiting logic here:
    // - Check if OTP was recently sent
    // - Prevent spam by limiting requests

    return await repository.requestOTP(email: params.email);
  }
}

class RequestOTPParams extends Equatable {
  final String email;

  const RequestOTPParams({required this.email});

  @override
  List<Object?> get props => [email];

  String? validate() {
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@')) return 'Invalid email format';
    return null;
  }
}