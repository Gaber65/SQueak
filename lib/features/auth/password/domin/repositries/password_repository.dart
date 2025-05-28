import '../entities/password_entity.dart';

abstract class PasswordRepository {
  Future<void> forgetPassword(String email);
  Future<void> resetPassword(PasswordEntity password);
  Future<void> verifyUser(String email, String token, String clinicCode);
}