// lib/features/authentication/domain/usecases/get_current_user.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  // ✅ FIXED: Use named parameter
  const GetCurrentUser({required this.repository});

  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}