// features/auth/password/domain/usecases/forget_password_usecase.dart

import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';

import '../password_failure.dart';
import 'package:dartz/dartz.dart';

class ForgetPasswordUseCase {
  final PasswordRepository repository;

  ForgetPasswordUseCase(this.repository);

  Future<Either<PasswordFailure, Unit>> call(String email) async {
    return await repository.forgetPassword(email);
  }
}