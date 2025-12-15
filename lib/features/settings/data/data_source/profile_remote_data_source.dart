import 'package:dio/dio.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../models/owner_model.dart';

abstract class ProfileRemoteDataSource {
  Future<OwnerModel> getOwnerData();
  Future<OwnerModel> updateProfile({
    required String fullName,
    required String address,
    required String imageName,
    required String birthDate,
    required int gender,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<OwnerModel> getOwnerData() async {
    try {
      Response response = await DioFinalHelper.getData(
        method: getProfileEndPoint,
        language: false,
      );
      return OwnerModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      final errorMessageModel = ErrorMessageModel.fromJson(e.response?.data);
      final error =
          errorMessageModel.errors.isNotEmpty
              ? errorMessageModel.errors.values.first.first
              : errorMessageModel.message;
      throw Exception(error);
    }
  }

  @override
  Future<OwnerModel> updateProfile({
    required String fullName,
    required String address,
    required String imageName,
    required String birthDate,
    required int gender,
  }) async {
    try {
      final response = await DioFinalHelper.putData(
        method: updatemyprofileEndPoint,
        data: {
          "fullName": fullName,
          "address": address,
          "imageName": imageName,
          "birthDate": birthDate,
          "gender": gender,
        },
      );
      return OwnerModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      final errorMessageModel = ErrorMessageModel.fromJson(e.response?.data);
      final error =
          errorMessageModel.errors.isNotEmpty
              ? errorMessageModel.errors.values.first.first
              : errorMessageModel.message;
      throw Exception(error);
    }
  }
}
