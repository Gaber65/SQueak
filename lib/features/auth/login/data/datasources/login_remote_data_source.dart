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
    String? fbToken;
    
    try {
      // Try to get cached token first
      fbToken = CacheHelper.getData('DeviceToken');
      
      // If no cached token, try to get from Firebase
      if (fbToken == null || fbToken.isEmpty) {
        try {
          fbToken = await FirebaseMessaging.instance.getToken();
          
          // Cache the token for future use
          if (fbToken != null) {
            CacheHelper.saveData('DeviceToken', fbToken);
          }
        } catch (firebaseError) {
          print('Firebase token error: $firebaseError');
          // Use a fallback token if Firebase fails
          fbToken = 'fallback_token_${DateTime.now().millisecondsSinceEpoch}';
        }
      }
    } catch (e) {
      print('Token retrieval error: $e');
      // Use a fallback token
      fbToken = 'fallback_token_${DateTime.now().millisecondsSinceEpoch}';
    }

    try {
      final response = await DioFinalHelper.postData(
        method: loginEndPoint,
        data: {
          'emailOrPhoneNumber': emailOrPhoneNumber,
          'password': password,
          'FbToken': fbToken ?? 'default_token',
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
