
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';
import 'package:squeak/features/auth/login/domin/repositries/log_repositry.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<LoginEntity> call({
    required String emailOrPhoneNumber,
    required String password,
  }) async {
    return await repository.login(
      emailOrPhoneNumber: emailOrPhoneNumber,
      password: password,
    );
  }
}