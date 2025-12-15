import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../entities/clinic_search_entity.dart';
import '../entities/vet_client_search_entity.dart';

abstract class BaseSearchRepository {
  Future<Either<Failure, List<ClinicEntitySearch>>> getSearchList(
    String clinicCode,
  );
  Future<Either<Failure, List<VetSearchClientEntity>>> getClintFormVetVoid(
    String clinicCode,
  );

  Future<Either<Failure, ClinicEntitySearch>> followClinic(String clinicId);
  Future<Either<Failure, ClinicEntitySearch>> unfollowClinic(String clinicId);

  Future<Either<Failure, SupplierEntitySearch>> getSupplier();
}
