import 'package:dio/dio.dart';
import 'package:squeak/core/network/config_model.dart';
import 'package:squeak/core/network/end-points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

class DataToken {
  final String token;
  final String tokenType;
  final DateTime expiresIn;
  final String refreshToken;

  DataToken({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
  });

  factory DataToken.fromJson(Map<String, dynamic> json) => DataToken(
    token: json["token"],
    tokenType: json["tokenType"],
    expiresIn: DateTime.parse(json["expiresIn"]),
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "tokenType": tokenType,
    "expiresIn": expiresIn.toIso8601String(),
    "refreshToken": refreshToken,
  };
}

class TokenManager {
  static Future<void> saveToken(
    String token,
    DateTime expiry,
    String refreshToken,
  ) async {
    await CacheHelper.saveData('token', token);
    await CacheHelper.saveData('refreshToken', refreshToken);
    await CacheHelper.saveData('expiry', expiry.toIso8601String());
  }

  static Future<bool> isAccessTokenExpired() async {
    await CacheHelper.init();
    final expiryString = CacheHelper.getData('expiry');
    if (expiryString == null) return true;
    try {
      final expiry = DateTime.parse(expiryString);
      return DateTime.now().isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  static Future<void> refreshToken() async {
    await CacheHelper.init();
    try {
      var dio = Dio();
      Response response = await dio.request(
        ConfigModel.baseApiUrlSqueak + refreshTokenGet,
        options: Options(
          method: 'POST',
          headers: {'Authorization': 'Bearer ${CacheHelper.getData('token')}'},
        ),
        data: {"token": CacheHelper.getData('refreshToken')},
      );
      DataToken jsonResponse = DataToken.fromJson(response.data["data"]);
      await saveToken(
        jsonResponse.token,
        jsonResponse.expiresIn,
        jsonResponse.refreshToken,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await CacheHelper.saveData('isExpiredToken', true);
      }
    }
  }
}
