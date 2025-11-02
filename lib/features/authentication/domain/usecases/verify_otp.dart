// lib/features/authentication/domain/usecases/verify_otp.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Verify OTP
///
/// Business action: Check if the OTP code user entered is correct
/// If correct, authenticate the user and return JWT token
class VerifyOTP {
  final AuthRepository repository;

  VerifyOTP(this.repository);

  /// Execute verification
  /// This is the critical moment - if OTP is correct, user is logged in!
  Future<Either<Failure, AuthResponse>> call(VerifyOTPParams params) async {
    // Could add business logic here:
    // - Check if OTP is expired (typically 5-10 minutes)
    // - Limit number of attempts (max 3-5 tries)
    // - Log failed attempts for security

    return await repository.verifyOTP(
      email: params.email,
      otp: params.otp,
    );
  }
}

class VerifyOTPParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOTPParams({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];

  String? validate() {
    if (email.isEmpty) return 'Email is required';
    if (otp.isEmpty) return 'OTP is required';
    if (otp.length != 6) return 'OTP must be 6 characters';
    return null;
  }
}