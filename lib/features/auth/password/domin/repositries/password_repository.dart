// features/auth/password/domain/repositories/password_repository.dart

import '../entities/password_entity.dart';
import '../password_failure.dart';
import 'package:dartz/dartz.dart';

abstract class PasswordRepository {
  Future<Either<PasswordFailure, Unit>> forgetPassword(String email);
  Future<Either<PasswordFailure, Unit>> resetPassword(PasswordEntity password);
  Future<Either<PasswordFailure, Unit>> verifyUser(String email, String token);
}