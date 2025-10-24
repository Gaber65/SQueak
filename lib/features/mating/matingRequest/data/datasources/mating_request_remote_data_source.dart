import 'package:dio/dio.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/matingRequest/data/models/mating_request_model.dart';

import '../../domain/entities/mating_request_entity.dart';

abstract class MatingRequestRemoteDataSource {
  Future<List<MatingRequestModel>> getMatingRequests(String petId);
  Future<List<MatingRequestModel>> getMatingSent(String petId);
  Future<String> updateRequestStatus(UpdateRequestStatusParams params);
}

class MatingRequestRemoteDataSourceImpl
    implements MatingRequestRemoteDataSource {
  @override
  Future<List<MatingRequestModel>> getMatingRequests(String petId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: getMatingRequestsEndPoint(petId),
      );
      return MatingRequestModel.fromJsonList(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<List<MatingRequestModel>> getMatingSent(String petId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: getMatingSentEndPoint(petId),
      );
      return MatingRequestModel.fromJsonList(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<String> updateRequestStatus(UpdateRequestStatusParams params) async {
    try {
      if (params.status != RequestStatus.canceled) {
        final result = await DioFinalHelper.putData(
          method: sendMatingRequestEndPoint,
          data: params.toJson(),
        );
        return result.data['data']['conversationId'];
      } else {
        final result = await DioFinalHelper.postData(
          method: cancelRequestEndPoint,
          data: params.toJson(),
        );
        return result.data['message'];
      }
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }
}
