import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/auth/login/data/models/login_data_model.dart';

import '../../domin/entities/user_auth_with_facebook.dart';

class AuthModel extends ErrorMessageModel {
  final LoginData? data;

  const AuthModel({
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


class SocialLoginModel extends SocialLoginEntity {
  SocialLoginModel({
    required super.accessToken,
    required super.refreshToken,
    required super.userId,
  });

  factory SocialLoginModel.fromJson(Map<String, dynamic> json) {
    return SocialLoginModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }
}