// data/datasources/remote_data_source.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:squeak/core/error/exception.dart';

import '../../../../network/dio.dart';
import '../../../../network/end_points.dart';
import '../../../../network/error_message_model.dart';
import '../../../cache/shared_preferences/cache_helper.dart';
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import '../models/image_model.dart';

class MainRemoteDataSource {
  Future<void> setLanguage(int language) async {
    try {
      await DioFinalHelper.putData(
        method: updateapplangauge,
        data: {"language": language},
      );
    } catch (e) {
      throw Exception('Failed to set language');
    }
  }

  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      throw Exception('Failed to delete token');
    }
  }

  Future<void> saveToken() async {
    try {
      // أولاً، نحاول الحصول على التوكن المخزن محلياً
      String? fbToken = CacheHelper.getData('DeviceToken');

      // إذا لم يكن هناك توكن محلي، نحاول الحصول عليه من Firebase
      if (fbToken == null || fbToken.isEmpty) {
        try {
          fbToken = await FirebaseMessaging.instance.getToken();
          if (fbToken != null) {
            // حفظ التوكن الجديد محلياً
            await CacheHelper.saveData('DeviceToken', fbToken);
          }
        } catch (tokenError) {
          // print('Error getting Firebase token in saveToken: $tokenError');
          // في حالة الفشل، نستخدم توكن مؤقت
          fbToken = 'temp_token_${DateTime.now().millisecondsSinceEpoch}';
          await CacheHelper.saveData('DeviceToken', fbToken);
        }
      }

      // إرسال التوكن للسيرفر
      final response = await DioFinalHelper.postData(
        method: sendtoken,
        data: {"fbToken": fbToken},
      );

      // التحقق من نجاح العملية
      if (response.statusCode == 201 || response.statusCode == 200) {
        // print('Token saved successfully');
      } else {
        throw Exception(
          'Failed to save token: unexpected status code ${response.statusCode}',
        );
      }
    } catch (e) {
      // print('Failed to save token: $e');
      // حذف التوكن المحلي في حالة الفشل لإتاحة المحاولة مرة أخرى
      await CacheHelper.removeData('DeviceToken');
      throw Exception('Failed to save token');
    }
  }

  Future<void> removeToken() async {
    try {
      final fbToken = CacheHelper.getData('DeviceToken');
      if (fbToken == null || fbToken.isEmpty) {
        // لا يوجد توكن للحذف
        return;
      }
      await DioFinalHelper.deleteData(
        method: sendtoken,
        data: {"fbToken": fbToken},
      );
      // حذف التوكن من التخزين المحلي بعد نجاح الحذف
      CacheHelper.removeData('DeviceToken');
    } catch (e) {
      // print('Failed to remove token: $e');
      // حذف التوكن من التخزين المحلي حتى لو فشل الطلب
      CacheHelper.removeData('DeviceToken');
      throw Exception('Failed to remove token');
    }
  }

  Future<void> requestNotificationPermissions() async {
    try {
      final status = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (status.authorizationStatus == AuthorizationStatus.authorized) {
        try {
          final token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            await CacheHelper.saveData('DeviceToken', token);
            // محاولة حفظ التوكن مباشرة بعد الحصول على الإذن
            await saveToken();
          }
        } catch (tokenError) {
          // print('Error getting Firebase token: $tokenError');
          // في حالة الفشل، نحاول استخدام التوكن المؤقت
          final tempToken =
              'temp_token_${DateTime.now().millisecondsSinceEpoch}';
          await CacheHelper.saveData('DeviceToken', tempToken);
        }
      } else {
        // print('Notification permissions not granted: ${status.authorizationStatus}');
      }
    } catch (permissionError) {
      // print('Error requesting notification permissions: $permissionError');
      // الاستمرار بدون توكن Firebase
    }
  }

  // دالة جديدة للتحقق من صلاحية التوكن وتحديثه إذا لزم الأمر
  Future<bool> validateAndRefreshToken() async {
    try {
      final currentToken = CacheHelper.getData('DeviceToken');
      final newToken = await FirebaseMessaging.instance.getToken();

      if (newToken != null && newToken != currentToken) {
        await CacheHelper.saveData('DeviceToken', newToken);
        await saveToken();
        return true;
      }
      return currentToken != null;
    } catch (e) {
      // print('Error validating token: $e');
      return false;
    }
  }

  Future<ImageModel> uploadFile(
    File file,
    String endpoint,
    int uploadPlace,
    String type,
    String subtype,
  ) async {
    String fileName = file.path.split('/').last;
    try {
      File fileToUpload = file;
      if (type == 'image') {
        fileToUpload = await compressImage(file);
      }
      String filePath = fileToUpload.path;
      debugPrint('📤 Uploading $type file: $fileName to endpoint: $endpoint');
      debugPrint('📦 Upload place: $uploadPlace, Content-Type: $type/$subtype');

      Response response = await DioFinalHelper.postData(
        method: endpoint,
        data: FormData.fromMap({
          "File": await MultipartFile.fromFile(
            filePath,
            filename: fileName,
            contentType: MediaType(type, subtype),
          ),
          'UploadPlace': '$uploadPlace',
        }),
      );
      return ImageModel.fromJson(response.data);
    } on DioException catch (e) {
      // Handle cases where response might be null (network errors, timeouts, etc.)
      if (e.response != null && e.response!.data != null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
        );
      } else {
        // Create a fallback error model for network/connection errors
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            errors: {},
            message: e.message ?? 'Network error occurred',
            success: false,
            statusCode: e.response?.statusCode ?? 0,
          ),
        );
      }
    }
  }

  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 800,
      minHeight: 800,
      quality: 50,
    );

    final compressedFile = File(file.path)..writeAsBytesSync(result!);
    return compressedFile;
  }

  String getImageSubtype(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'bmp':
        return 'bmp';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg';
    }
  }

  String getVideoSubtype(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'mp4':
        return 'mp4';
      case 'mov':
        return 'quicktime';
      case 'avi':
        return 'x-msvideo';
      case 'mkv':
        return 'x-matroska';
      case 'flv':
        return 'x-flv';
      case 'wmv':
        return 'x-ms-wmv';
      case '3gp':
        return '3gpp';
      case 'm4v':
        return 'x-m4v';
      case 'webm':
        return 'webm';
      default:
        return 'mp4';
    }
  }
}
