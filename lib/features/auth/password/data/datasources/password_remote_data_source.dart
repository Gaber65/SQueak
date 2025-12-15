// password_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PasswordRemoteDataSource {
  // Method to forget password
  Future<ErrorMessageModel> forgetPassword(String email) async {
    try {
      final response = await DioFinalHelper.postData(
        method: forgetPasswordEndPoint,
        data: {"email": email},
      );
      return ErrorMessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  // Method to reset password
  Future<ErrorMessageModel> resetPassword(
    String email,
    String tokenCode,
    String newPassword,
  ) async {
    try {
      final response = await DioFinalHelper.postData(
        method: resetPasswordEndPoint,
        data: {
          "email": email,
          "tokenCode": tokenCode,
          "newPassword": newPassword,
          "confirmNewPassword": newPassword,
        },
      );
      return ErrorMessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  // Method to verify user
  Future<ErrorMessageModel> verifyUser(
    String email,
    String tokenCode,
    String clinicCode,
  ) async {
    try {
      final response = await DioFinalHelper.postData(
        method: verificationCodeEndPoint,
        data: {
          "email": email,
          "tokenCode": tokenCode,
          "clinicCode": clinicCode,
        },
      );
      return ErrorMessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
