// features/auth/password/domain/entities/password_entity.dart

class PasswordEntity {
  final String? email;
  final String? token;
  final String? newPassword;

  const PasswordEntity({
    this.email,
    this.token,
    this.newPassword,
  });
}