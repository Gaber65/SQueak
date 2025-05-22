import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';

abstract class LoginRepository {
    Future<LoginEntity> login({
    required String emailOrPhoneNumber,
    required String password,
  });
}