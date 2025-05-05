import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/version_model.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

abstract class LayoutRemoteDataSource {
  Future<VersionModel> getVersion();
}

class LayoutRemoteDataSourceImpl implements LayoutRemoteDataSource {
  LayoutRemoteDataSourceImpl();

  @override
  Future<VersionModel> getVersion() async {
    try {
      var getVersionEndPointBasedOnOS =
          Platform.isAndroid ? getVersionEndPoint : getVersionEndPointIOS;

      Response response = await DioFinalHelper.getData(
        method: getVersionEndPointBasedOnOS,
        language: true,
      );

      return VersionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
