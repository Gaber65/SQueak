import 'package:dio/dio.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';

abstract class QrRemoteDataSource {
  Future<bool> linkPetToQr(String petId, String qrCodeId);
  Future<bool> unlinkPetFromQr(String petId, String qrCodeId);
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  @override
  Future<bool> linkPetToQr(String petId, String qrCodeId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: qrScanEndPoint,
        data: {
          "petId": petId,
          "qrCodeId": extractAllIdsFromUrl(qrCodeId),
          "qrCode": qrCodeId,
        },
      );
      return response.data['success'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<bool> unlinkPetFromQr(String petId, String qrCodeId) async {
    try {
      final response = await DioFinalHelper.putData(
        method: qrScanEndPoint,
        data: {"petId": petId, "qrCodeId": qrCodeId},
      );
      return response.data['success'] ?? false;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
