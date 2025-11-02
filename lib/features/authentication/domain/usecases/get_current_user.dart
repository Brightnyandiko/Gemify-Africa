// lib/features/authentication/domain/usecases/get_current_user.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Get Current User
///
/// Business action: Retrieve information about the logged-in user
/// Used when app starts to check who's logged in
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  /// No parameters needed - we're getting the CURRENT user
  /// The repository will use the stored JWT token to identify them
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}