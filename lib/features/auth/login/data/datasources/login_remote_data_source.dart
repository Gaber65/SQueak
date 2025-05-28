import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:squeak/features/auth/login/data/models/auth_model.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

class LoginRemoteDataSource {
  Future<AuthModel> login({
    required String emailOrPhoneNumber,
    required String password,
  }) async {
    final fbToken =
        CacheHelper.getData('DeviceToken') ??
        await FirebaseMessaging.instance.getToken();

    try {
      final response = await DioFinalHelper.postData(
        method: loginEndPoint,
        data: {
          'emailOrPhoneNumber': emailOrPhoneNumber,
          'password': password,
          'FbToken': fbToken,
          'IOSDevice': Platform.isIOS,
          'Androidevice': Platform.isAndroid,
        },
      );
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
