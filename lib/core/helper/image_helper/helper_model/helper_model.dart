class HelperModel {
  HelperModel({
    required this.success,
    required this.errors,
    required this.data,
    required this.message,
    required this.statusCode,
  });
  late final bool success;
  late final Errors errors;
  late final String? data;
  late final String message;
  late final int statusCode;

  HelperModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errors = Errors.fromJson(json['errors']);
    data = json['message'];
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['errors'] = errors.toJson();
    _data['data'] = data;
    _data['message'] = message;
    _data['statusCode'] = statusCode;
    return _data;
  }
}

class Errors {
  Errors();

  Errors.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

