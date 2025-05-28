import 'package:dartz/dartz.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/features/vetcare/domain/entities/vet_client.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';

abstract class QRRepository {
  Future<Either<Failure, bool>> checkClinicInSupplier(CheckClinicParams params);
  Future<Either<Failure, bool>> followClinic(FollowClinicParams params);
  Future<Either<Failure, List<VetClient>>> getVetClients(
    GetVetClientsParams params,
  );
}

class GetVetClientsParams {
  final String code;
  final bool isFilter;

  GetVetClientsParams({required this.code, required this.isFilter});
}

class FollowClinicParams {
  final String clinicCode;

  FollowClinicParams({required this.clinicCode});
}

class CheckClinicParams {
  final String clinicCode;
  final MySupplier suppliers;

  CheckClinicParams({required this.clinicCode, required this.suppliers});
}
