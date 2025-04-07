class RefreshToken {
  RefreshToken({
    required this.success,
    required this.data,
    required this.message,
    required this.statusCode,
  });
  late final bool success;
  late final Data data;
  late final String message;
  late final int statusCode;

  RefreshToken.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = Data.fromJson(json['data']);
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    _data['message'] = message;
    _data['statusCode'] = statusCode;
    return _data;
  }
}


class Data {
  Data({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
  });
  late final String token;
  late final String tokenType;
  late final String expiresIn;
  late final String refreshToken;

  Data.fromJson(Map<String, dynamic> json){
    token = json['token'];
    tokenType = json['tokenType'];
    expiresIn = json['expiresIn'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['tokenType'] = tokenType;
    _data['expiresIn'] = expiresIn;
    _data['refreshToken'] = refreshToken;
    return _data;
  }
}