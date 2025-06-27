import '../../domain/entities/qr_code_entity.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_remote_datasource.dart';
import '../../../pets/domain/entities/pet_entity.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDataSource remoteDataSource;

  QrRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> linkPetToQr(String petId, String qrCodeId) async {
    return await remoteDataSource.linkPetToQr(petId, qrCodeId);
  }

  @override
  Future<bool> unlinkPetFromQr(String petId) async {
    return await remoteDataSource.unlinkPetFromQr(petId);
  }

  @override
  Future<QrCodeEntity?> getQrCodeByPetId(String petId) async {
    return await remoteDataSource.getQrCodeByPetId(petId);
  }

  @override
  Future<PetEntities?> getPetByQrCode(String qrCodeId) async {
    return await remoteDataSource.getPetByQrCode(qrCodeId);
  }

  @override
  Future<String> generateQrCode(String petId) async {
    return await remoteDataSource.generateQrCode(petId);
  }

  @override
  Future<bool> downloadQrCode(String qrCodeId, String petName) async {
    return await remoteDataSource.downloadQrCode(qrCodeId, petName);
  }

  @override
  Future<void> sendScanNotification(String qrCodeId, String petId, {Map<String, double>? location}) async {
    return await remoteDataSource.sendScanNotification(qrCodeId, petId, location: location);
  }

  @override
  Future<bool> validateQrCode(String qrCodeId) async {
    return await remoteDataSource.validateQrCode(qrCodeId);
  }
}
