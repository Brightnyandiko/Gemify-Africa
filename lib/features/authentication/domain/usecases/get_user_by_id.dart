// lib/features/authentication/domain/usecases/get_user_by_id.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Get User By ID
///
/// Business action: Fetch a specific user's information
/// Useful for viewing profiles, admin functions, etc.
class GetUserById {
  final AuthRepository repository;

  GetUserById(this.repository);

  Future<Either<Failure, User>> call(GetUserByIdParams params) async {
    return await repository.getUserById(params.userId);
  }
}

class GetUserByIdParams extends Equatable {
  final int userId;

  const GetUserByIdParams({required this.userId});

  @override
  List<Object?> get props => [userId];

  String? validate() {
    if (userId <= 0) return 'Invalid user ID';
    return null;
  }
}