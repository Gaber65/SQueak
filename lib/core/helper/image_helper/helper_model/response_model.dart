class ResponseModel {
  final Map<String, List<dynamic>> errors;
  final String message;
  final int statusCode;
  final bool success;


  ResponseModel({
    required this.errors,
    required this.message,
    required this.success,
    required this.statusCode,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      errors: Map<String, List<dynamic>>.from(json['errors']),
      message: json['message'],
      success: json['success'],
      statusCode: json['statusCode'],
    );
  }

  static Map<String, List<dynamic>> convertJsonToMap(Map<String, dynamic> json) {
    return Map<String, List<dynamic>>.from(json['errors']);
  }
}
