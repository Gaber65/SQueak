// features/auth/password/domain/password_failure.dart

abstract class PasswordFailure {
  final String message;
  const PasswordFailure(this.message);
}

class ServerFailure extends PasswordFailure {
  const ServerFailure(String message) : super(message);
}

class InvalidEmailFailure extends PasswordFailure {
  const InvalidEmailFailure() : super('Invalid email format');
}

class InvalidCodeFailure extends PasswordFailure {
  const InvalidCodeFailure() : super('Invalid verification code');
}

class WeakPasswordFailure extends PasswordFailure {
  const WeakPasswordFailure() : super('Password is too weak');
}