import '../entities/qr_code_entity.dart';
import '../../../pets/domain/entities/pet_entity.dart';

abstract class QrRepository {
  Future<bool> linkPetToQr(String petId, String qrCodeId);
  Future<bool> unlinkPetFromQr(String petId);
  Future<QrCodeEntity?> getQrCodeByPetId(String petId);
  Future<PetEntities?> getPetByQrCode(String qrCodeId);
  Future<String> generateQrCode(String petId);
  Future<bool> downloadQrCode(String qrCodeId, String petName);
  Future<void> sendScanNotification(String qrCodeId, String petId, {Map<String, double>? location});
  Future<bool> validateQrCode(String qrCodeId);
}
