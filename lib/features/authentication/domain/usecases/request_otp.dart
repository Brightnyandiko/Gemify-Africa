// lib/features/authentication/domain/usecases/request_otp.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class RequestOTP {
  final AuthRepository repository;

  // ✅ FIXED: Use named parameter
  const RequestOTP({required this.repository});

  Future<Either<Failure, String>> call(RequestOTPParams params) async {
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