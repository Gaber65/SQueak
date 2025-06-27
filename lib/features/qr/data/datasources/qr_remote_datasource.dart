import 'package:dio/dio.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';


abstract class QrRemoteDataSource {
  Future<bool> linkPetToQr(String petId, String qrCodeId);
  Future<bool> unlinkPetFromQr(String petId);

}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  @override
  Future<bool> linkPetToQr(String petId, String qrCodeId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: qrScanEndPoint,
        data: {
          "petId": petId,
          "qrCodeId": extractQRIdFromUrl(qrCodeId),
          "qrCode": qrCodeId
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
  Future<bool> unlinkPetFromQr(String petId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: '/qr/unlink',
        data: {'petId': petId},
      );
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to unlink pet from QR: $e');
    }
  }


}
