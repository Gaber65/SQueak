import 'package:dio/dio.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import '../../domain/entities/qr_code_entity.dart';
import '../../../pets/domain/entities/pet_entity.dart';

abstract class QrRemoteDataSource {
  Future<bool> linkPetToQr(String petId, String qrCodeId);
  Future<bool> unlinkPetFromQr(String petId);
  Future<QrCodeEntity?> getQrCodeByPetId(String petId);
  Future<PetEntities?> getPetByQrCode(String qrCodeId);
  Future<String> generateQrCode(String petId);
  Future<bool> downloadQrCode(String qrCodeId, String petName);
  Future<void> sendScanNotification(
    String qrCodeId,
    String petId, {
    Map<String, double>? location,
  });
  Future<bool> validateQrCode(String qrCodeId);
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  @override
  Future<bool> linkPetToQr(String petId, String qrCodeId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: '/qr/link',
        data: {'petId': petId, 'qrCodeId': qrCodeId},
      );
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to link pet to QR: $e');
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

  @override
  Future<QrCodeEntity?> getQrCodeByPetId(String petId) async {
    try {
      final response = await DioFinalHelper.getData(
        language: false,
        method: '/qr/pet/$petId',
      );
      if (response.data != null) {
        return QrCodeEntity.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null; // No QR code linked
    }
  }

  @override
  Future<PetEntities?> getPetByQrCode(String qrCodeId) async {
    try {
      final response = await DioFinalHelper.getData(
        language: false,
        method: '/qr/scan/$qrCodeId',
      );
      if (response.data['success'] && response.data['petData'] != null) {
        return PetData.fromJson(response.data['petData']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get pet by QR: $e');
    }
  }

  @override
  Future<String> generateQrCode(String petId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: '/qr/generate',
        data: {'petId': petId},
      );
      return response.data['qrCodeId'] ?? '';
    } catch (e) {
      throw Exception('Failed to generate QR code: $e');
    }
  }

  @override
  Future<bool> downloadQrCode(String qrCodeId, String petName) async {
    try {
      final response = await DioFinalHelper.getData(
        language: false,
        method: '/qr/download/$qrCodeId',
      );

      // Here you would save the file to device storage
      // For now, we'll just return success
      return true;
    } catch (e) {
      throw Exception('Failed to download QR code: $e');
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
        method: '/notifications/scan',
        data: {'qrId': qrCodeId, 'petId': petId, 'location': location},
      );
    } catch (e) {
      // Don't throw error for notification failure
      print('Failed to send scan notification: $e');
    }
  }

  @override
  Future<bool> validateQrCode(String qrCodeId) async {
    try {
      final response = await DioFinalHelper.getData(
        language: false,
        method: '/qr/validate/$qrCodeId',
      );
      return response.data['isValid'] ?? false;
    } catch (e) {
      return false;
    }
  }
}
