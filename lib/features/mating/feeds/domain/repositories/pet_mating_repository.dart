
import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/pet_mating_entity.dart';
import '../entities/mating_request_entity.dart';
import '../usecases/mating_parameters.dart';


abstract class BasePetMatingRepository {
  Future<Either<Failure, List<PetMatingEntity>>> getAvailablePets();
  Future<Either<Failure, List<PetMatingEntity>>> getPetsByStatus(PetMatingStatus status);
  Future<Either<Failure, MatingRequestEntity>> sendMatingRequest(SendMatingRequestParameters parameters);
  Future<Either<Failure, PetMatingEntity>> getPetProfile(String petId);
  Future<Either<Failure, void>> updatePetStatus(UpdatePetStatusParameters parameters);
}