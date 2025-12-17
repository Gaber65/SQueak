import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';

class ForgetPasswordUseCase {
  final PasswordRepository repository;

  ForgetPasswordUseCase(this.repository);

  Future<void> call(String email) async {
    return await repository.forgetPassword(email);
  }
}
