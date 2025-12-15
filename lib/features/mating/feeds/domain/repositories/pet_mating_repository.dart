import 'package:dartz/dartz.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

import '../usecases/mating_parameters.dart';

abstract class BasePetMatingRepository {
  Future<Either<Failure, List<PetEntities>>> getAvailablePets(String specieId);
  Future<Either<Failure, String>> sendMatingRequest(
    SendMatingRequestParameters parameters,
  );
  Future<Either<Failure, void>> updateSentRequestStatus(
    SendMatingRequestParameters parameters,
  );
}
