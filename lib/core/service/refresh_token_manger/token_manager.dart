import 'package:dio/dio.dart';


import '../../network/config_model.dart';
import '../../network/end-points.dart';
import '../cache/shared_preferences/cache_helper.dart';

void callbackDispatcher() {
  // Workmanager().executeTask((task, inputData) async {
  //   print('Executing refresh token task');
  //   TokenManager tokenManager = TokenManager();
  //   await CacheHelper.init();
  //   await tokenManager.refreshToken();
  //   return Future.value(true);
  // });
}

class DataToken {
  String token;
  String tokenType;
  DateTime expiresIn;
  String refreshToken;

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
  Future<void> saveToken(
    String token,
    DateTime expiry,
    String refreshToken,
  ) async {
    CacheHelper.saveData('token', token);
    CacheHelper.saveData('refreshToken', refreshToken);
    CacheHelper.saveData('expiry', expiry.millisecondsSinceEpoch);
  }

  Future<void> refreshToken() async {
    CacheHelper.init();
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
      String newToken = jsonResponse.token;
      String newRefreshToken = jsonResponse.refreshToken;
      DateTime newExpiry = DateTime.now().add(Duration(hours: 6));
      await saveToken(newToken, newExpiry, newRefreshToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        CacheHelper.saveData('isExpiredToken', true);
      }
    }
  }
}
