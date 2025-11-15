// lib/features/authentication/domain/usecases/verify_otp.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class VerifyOTP {
  final AuthRepository repository;

  // ✅ FIXED: Use named parameter
  const VerifyOTP({required this.repository});

  Future<Either<Failure, AuthResponse>> call(VerifyOTPParams params) async {
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