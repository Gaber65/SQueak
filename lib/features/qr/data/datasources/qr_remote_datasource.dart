import 'package:dio/dio.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import '../../../pets/domain/entities/pet_entity.dart';

abstract class QrRemoteDataSource {
  Future<bool> linkQr(String petId, String qrCodeId);
  Future<bool> unlinkQr(String petId);
  Future<PetEntities?> scanQr(String qrCodeId);
  Future<void> sendScanNotification(
    String qrCodeId,
    String petId, {
    Map<String, double>? location,
  });
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  @override
  Future<bool> linkQr(String petId, String qrCodeId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: '/qr/link',
        data: {'petId': petId, 'qrCodeId': qrCodeId},
      );
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to link QR: $e');
    }
  }

  @override
  Future<bool> unlinkQr(String petId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: '/qr/unlink',
        data: {'petId': petId},
      );
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to unlink QR: $e');
    }
  }

  @override
  Future<PetEntities?> scanQr(String qrCodeId) async {
    try {
      final response = await DioFinalHelper.getData(
        method: '/qr/scan',
        language: true,
      );
      if (response.data['success'] && response.data['petData'] != null) {
        return PetData.fromJson(response.data['petData']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to scan QR: $e');
    }
  }

  @override
  Future<void> sendScanNotification(
    String qrCodeId,
    String petId, {
    Map<String, double>? location,
  }) async {
    try {
      await DioFinalHelper.postData(
        method: '/qr/scan-notification',
        data: {'qrId': qrCodeId, 'petId': petId, 'location': location},
      );
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }
}
