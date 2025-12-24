class SocialLoginEntity {
  final String accessToken;
  final String refreshToken;
  final String userId;
  SocialLoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });
}
