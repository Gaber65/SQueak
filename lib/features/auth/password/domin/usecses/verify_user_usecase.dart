
import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';

class VerifyUserUseCase {
  final PasswordRepository repository;

  VerifyUserUseCase(this.repository);

  Future<void> call(String email, String token, String clinic) async {
    return await repository.verifyUser(email, token, clinic);
  }
}