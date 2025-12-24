import 'package:dio/dio.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/features/auth/login/data/models/auth_model.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_with_facebook.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/network/error_message_model.dart';
import '../models/login_data_model.dart';

abstract class SocailAuthRemoteDataSource {
  Future<LoginData> signInFacebook(LoginWithFacebookPrames params);

  Future<LoginData> signInGoogle(LoginWithFacebookPrames params);
}

class SocailAuthRemoteDataSourceImpl implements SocailAuthRemoteDataSource {
  @override
  Future<LoginData> signInFacebook(LoginWithFacebookPrames params) async {
    try {
      final response = await DioFinalHelper.postData(
        method: loginFacebookEndPoint,
        data: params.toJsonFacebook(),
      );

      return LoginData.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
      );
    }
  }

  @override
  Future<LoginData> signInGoogle(LoginWithFacebookPrames params) async {
    try {
      final response = await DioFinalHelper.postData(
        method: loginFacebookEndPoint,
        data: params.toJsonFacebook(),
      );

      return LoginData.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
      );
    }
  }
}
