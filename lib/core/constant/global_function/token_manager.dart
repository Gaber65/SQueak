import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:squeak/core/helper/remotely/config_model.dart';
import 'package:dio/dio.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart';

import '../../../features/pets/models/pet_model.dart';



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
      String token, DateTime expiry, String refreshToken) async {
    print('saveData');
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
        data: {
          "token": CacheHelper.getData('refreshToken'),
        },
      );
      DataToken jsonResponse = DataToken.fromJson(response.data["data"]);
      String newToken = jsonResponse.token;
      String newRefreshToken = jsonResponse.refreshToken;
      DateTime newExpiry = DateTime.now().add(Duration(hours: 6));
      print('new token Successfully');
      await saveToken(newToken, newExpiry, newRefreshToken);
      print(jsonResponse.toJson());
    } on DioException catch (e) {
      print(e.response?.data);
      print('refresh token error ${e.response?.data}');
      if (e.response?.statusCode == 401) {
        CacheHelper.saveData('isExpiredToken', true);
      }
    }
  }
}
