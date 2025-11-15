// lib/features/authentication/domain/usecases/logout.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  // ✅ FIXED: Use named parameter
  const Logout({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}