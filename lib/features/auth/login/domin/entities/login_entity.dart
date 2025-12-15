class LoginEntity {
  final String token;
  final String refreshToken;
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final int role;
  final DateTime expiresIn;
  final bool? loggedInBefore;

  const LoginEntity({
    required this.token,
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.refreshToken,
    required this.expiresIn,
    this.loggedInBefore = false,
  });
}
