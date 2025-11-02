// lib/features/authentication/domain/usecases/logout.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Logout
///
/// Business action: End the user's session
/// Clears tokens, user data, and any cached information
class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  /// Execute logout
  /// Returns void on success (nothing to return, just confirm it worked)
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}