import '../../../core/helper/image_helper/helper_model/response_model.dart';




class AuthModel extends ResponseModel {
  final LoginData? data;

  AuthModel({
    required this.data,
    required super.errors,
    required super.message,
    required super.statusCode,
    required super.success,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      errors: Map<String, List<dynamic>>.from(json['errors']),
      message: json['message'],
      statusCode: json['statusCode'],
      success: json['success'],
    );
  }
}

class LoginData {
  final String token;
  final String refreshToken;
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final int role;

  const LoginData({
    required this.token,
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.refreshToken,
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
    );
  }
}
