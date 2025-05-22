// features/auth/password/domain/usecases/reset_password_usecase.dart

import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';

import '../password_failure.dart';
import '../entities/password_entity.dart';
import 'package:dartz/dartz.dart';

class ResetPasswordUseCase {
  final PasswordRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<PasswordFailure, Unit>> call(PasswordEntity password) async {
    return await repository.resetPassword(password);
  }
}