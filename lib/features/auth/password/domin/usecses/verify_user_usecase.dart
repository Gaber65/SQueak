// features/auth/password/domain/usecases/verify_user_usecase.dart

import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';

import '../password_failure.dart';
import 'package:dartz/dartz.dart';

class VerifyUserUseCase {
  final PasswordRepository repository;

  VerifyUserUseCase(this.repository);

  Future<Either<PasswordFailure, Unit>> call(String email, String token) async {
    return await repository.verifyUser(email, token);
  }
}