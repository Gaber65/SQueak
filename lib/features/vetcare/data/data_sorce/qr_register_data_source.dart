// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../models/vet_client_model.dart';

abstract class QRRemoteDataSource {
  Future<bool> checkClinicInSupplier(CheckClinicParams params);
  Future<void> followClinic(FollowClinicParams params);
  Future<List<VetClientModel>> getVetClients(GetVetClientsParams params);
}

// Data Layer - Data Source Implementation
class QRRemoteDataSourceImpl implements QRRemoteDataSource {

  @override
  Future<bool> checkClinicInSupplier(CheckClinicParams params) async {
    // print('checkClinicInSupplier');
    // print(params.clinicCode);
    for (var element in params.suppliers.data) {
      // print(element.data.code);
    }

    try {
      if (params.suppliers.data.isNotEmpty) {
        return params.suppliers.data.any(
          (element) {
            return element.data.code == params.clinicCode;
          },
        );
      }
      return false;
    } catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          errors: {},
          message: 'Failed to check clinic in supplier: ${e.toString()}',
          success: false,
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<void> followClinic(FollowClinicParams params) async {
    try {
      await DioFinalHelper.postData(
        method: followQrEndPoint,
        data: {
          "clinicCode": params.clinicCode,
          "allToShareDataWithVetICare": true,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<List<VetClientModel>> getVetClients(GetVetClientsParams params) async {
    try {
      Response response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(
          params.code,
          CacheHelper.getData('phone'),
        ),
        language: true,
      );

      List<VetClientModel> vetClientModel = List<VetClientModel>.from(
        response.data["data"].map((x) => VetClientModel.fromJson(x)),
      );

      if (params.isFilter) {
        vetClientModel =
            vetClientModel
                .where((element) => element.addedInSqueakStatues == false)
                .toList();
      }

      return vetClientModel;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }
}
