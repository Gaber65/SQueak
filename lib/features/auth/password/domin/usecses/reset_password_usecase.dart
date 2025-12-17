import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';
import '../entities/password_entity.dart';

class ResetPasswordUseCase {
  final PasswordRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call(PasswordEntity password) async {
    return await repository.resetPassword(password);
  }
}
