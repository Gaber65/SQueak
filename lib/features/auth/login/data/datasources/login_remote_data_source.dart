import 'dart:io';
import 'package:dio/dio.dart';

import 'package:squeak/features/auth/login/data/models/auth_model.dart';
import 'package:squeak/core/utils/firebase_token_helper.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

class LoginRemoteDataSource {
  Future<AuthModel> login({
    required String emailOrPhoneNumber,
    required String password,
  }) async {
    // Get Firebase token using the enhanced helper
    final fbToken =
        await FirebaseTokenHelper.getFirebaseToken() ??
        'fallback_token_${DateTime.now().millisecondsSinceEpoch}';

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
