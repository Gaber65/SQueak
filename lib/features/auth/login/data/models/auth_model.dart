
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/auth/login/data/models/login_data_model.dart';

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
