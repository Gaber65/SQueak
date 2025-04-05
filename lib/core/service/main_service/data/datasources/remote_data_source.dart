// data/datasources/remote_data_source.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:squeak/core/error/exception.dart';

import '../../../../network/dio.dart';
import '../../../../network/end-points.dart';
import '../../../../network/error_message_model.dart';
import '../../../cache/shared_preferences/cache_helper.dart';
import 'dart:async';
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
      await DioFinalHelper.postData(
        method: sendtoken,
        data: {
          "fbToken":
              CacheHelper.getData('DeviceToken') ??
              await FirebaseMessaging.instance.getToken(),
        },
      );
    } catch (e) {
      throw Exception('Failed to save token');
    }
  }

  Future<void> removeToken() async {
    try {
      await DioFinalHelper.deleteData(
        method: sendtoken,
        data: {"fbToken": CacheHelper.getData('DeviceToken')},
      );
    } catch (e) {
      throw Exception('Failed to remove token');
    }
  }

  Future<void> requestNotificationPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final token = await FirebaseMessaging.instance.getToken();
    CacheHelper.saveData('DeviceToken', token);
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
      File compressedFile = await compressImage(file);

      String compressedFilePath = compressedFile.path;
      Response response = await DioFinalHelper.postData(
        method: imageHelperEndPoint,
        data: FormData.fromMap({
          "File": await MultipartFile.fromFile(
            compressedFilePath,
            filename: fileName,
            contentType: MediaType(type, subtype),
          ),
          'UploadPlace': '$uploadPlace',
        }),
      );
      return ImageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
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
}
