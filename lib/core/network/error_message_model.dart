import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final Map<String, List<dynamic>> errors;
  final String message;
  final int statusCode;
  final bool success;

  const ErrorMessageModel({
    required this.errors,
    required this.message,
    required this.success,
    required this.statusCode,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      errors: Map<String, List<dynamic>>.from(json['errors']),
      message: json['message'],
      success: json['success'],
      statusCode: json['statusCode'],
    );
  }


  static Map<String, List<dynamic>> convertJsonToMap(Map<String, dynamic> json) {
    return Map<String, List<dynamic>>.from(json['errors']);
  }
  @override
  List<Object?> get props => [errors, message, success, statusCode];
}
