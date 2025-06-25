import '../../../pets/domain/entities/pet_entity.dart';

abstract class QrRepository {
  Future<bool> linkQr(String petId, String qrCodeId);
  Future<bool> unlinkQr(String petId);
  Future<PetEntities?> scanQr(String qrCodeId);
  Future<void> sendScanNotification(String qrCodeId, String petId, {Map<String, double>? location});
}
