import '../../../pets/domain/entities/pet_entity.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_remote_datasource.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDataSource remoteDataSource;

  QrRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> linkQr(String petId, String qrCodeId) async {
    return await remoteDataSource.linkQr(petId, qrCodeId);
  }

  @override
  Future<bool> unlinkQr(String petId) async {
    return await remoteDataSource.unlinkQr(petId);
  }

  @override
  Future<PetEntities?> scanQr(String qrCodeId) async {
    return await remoteDataSource.scanQr(qrCodeId);
  }

  @override
  Future<void> sendScanNotification(String qrCodeId, String petId, {Map<String, double>? location}) async {
    return await remoteDataSource.sendScanNotification(qrCodeId, petId, location: location);
  }
}
