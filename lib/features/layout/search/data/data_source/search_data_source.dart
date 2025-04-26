import 'package:dio/dio.dart';
import '../../../../../core/utils/export_path/export_files.dart';
import '../model/clinic_search_model.dart';
import '../model/vet_client_search_model.dart';

abstract class BaseSearchRemoteDataSource {
  Future<List<ClinicModelSearch>> getSearchList(String clinicCode);
  Future<List<VetSearchClientModel>> getClientFormVet(String clinicCode);
  Future<ClinicModelSearch> followClinic(String clinicId);
  Future<ClinicModelSearch> unfollowClinic(String clinicId);
  Future<SupplierModelSearch> getSupplier();
}

class SearchRemoteDataSource extends BaseSearchRemoteDataSource {
  @override
  Future<List<ClinicModelSearch>> getSearchList(String clinicCode) async {
    try {
      Response result = await DioFinalHelper.getData(
        method: '$addClinicEndPoint?Code=$clinicCode',
        language: true,
      );
      return (result.data['data']['clinics'] as List)
          .map((e) => ClinicModelSearch.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<VetSearchClientModel>> getClientFormVet(String clinicCode) async {
    try {
      Response result = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(
          clinicCode,
          CacheHelper.getData('phone'),
        ),
        language: true,
      );
      return (result.data['data'] as List)
          .map((e) => VetSearchClientModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<ClinicModelSearch> followClinic(String clinicId) async {
    try {
      Response result = await DioFinalHelper.postData(
        method: unfollowClinicEndPoint,
        data: {"clinicId": clinicId},
      );
      return ClinicModelSearch.fromJson(result.data['data']['result']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<ClinicModelSearch> unfollowClinic(String clinicId) async {
    try {
      Response result = await DioFinalHelper.postData(
        method: unfollowClinicEndPoint,
        data: {"clinicId": clinicId},
      );
      return ClinicModelSearch.fromJson(result.data['data']['result']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<SupplierModelSearch> getSupplier() async {
    try {
      Response result = await DioFinalHelper.getData(
        method: getFollowerClinicEndPoint,
        language: false,
      );
      return SupplierModelSearch.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
