import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';

class LoginData extends LoginEntity {
  LoginData({
    required super.token,
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.role,
    required super.refreshToken,
    required super.expiresIn,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'],
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      refreshToken: json['refreshToken'],
      expiresIn: DateTime.parse(json["expiresIn"]),
    );
  }
}
