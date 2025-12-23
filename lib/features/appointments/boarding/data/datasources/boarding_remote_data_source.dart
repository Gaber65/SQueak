// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../models/boarding_entry_model.dart';
import '../models/boarding_type_model.dart';

abstract class BoardingRemoteDataSource {
  Future<List<BoardingTypeModel>> getBoardingTypes(String clinicCode);
  Future<void> createBoarding(CreateBoardingParams params);
  Future<void> editBoarding(EditBoardingParams params);
  Future<List<BoardingEntryModel>> getBoardingEntries(
    String phone,
    bool applyFilter,
  );
  Future<void> rateBoarding(RateBoardingParams params);
  Future<void> shareImage(ShareImageBoardingEntriesParams params);
}

class BoardingRemoteDataSourceImpl implements BoardingRemoteDataSource {
  BoardingRemoteDataSourceImpl();

  @override
  Future<List<BoardingTypeModel>> getBoardingTypes(String clinicCode) async {
    try {
      final response = await DioFinalHelper.getData(
        method: boardingTypeEndPoint(clinicCode),
        language: true,
      );
      final List<dynamic> data = response.data['data'];
      return data
          .map((json) => BoardingTypeModel.fromJson(json))
          .where((type) => type.isActive)
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
      );
    }
  }

  @override
  Future<void> createBoarding(CreateBoardingParams params) async {
    try {
      await DioFinalHelper.postData(
        method: createBoardingEndPoint,
        data: params.toMap(),
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
      );
    }
  }

  @override
  Future<void> editBoarding(EditBoardingParams params) async {
    try {
      await DioFinalHelper.putData(
        method: editBoardingEndPoint,
        data: params.toMap(),
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
      );
    }
  }

  @override
  Future<List<BoardingEntryModel>> getBoardingEntries(
    String phone,
    bool applyFilter,
  ) async {


    try {
      Response response = await DioFinalHelper.getData(
        method: getAllBoardingEndPoint(CacheHelper.getData('phone')),
        language: false,
      );

      return (response.data['data']['result'] as List)
          .map((e) => BoardingEntryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
      );
    }
  }

  @override
  Future<void> rateBoarding(RateBoardingParams params) async {
    try {
      await DioFinalHelper.postData(
        method: rateBoardingEndPoint,
        data: params.toMap(),
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
      );
    }
  }

  @override
  Future<void> shareImage(ShareImageBoardingEntriesParams params) async {
    try {
      // Download the image
      final response = await Dio().get<List<int>>(
        params.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Get a temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/boarding-image.jpg';

      // Write to file
      final file = File(filePath);
      await file.writeAsBytes(response.data!);

      // Share it using share_plus
      await Share.shareXFiles([
        XFile(filePath),
      ], text: "Look at my pet's boarding photo on $params!");
    } catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          errors: {},
          message: 'Failed to share image: $e',
          success: false,
          statusCode: 500,
        ),
      );
    }
  }
}
