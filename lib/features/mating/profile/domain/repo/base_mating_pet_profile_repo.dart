import 'package:dartz/dartz.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/domain/entities/history_entities.dart';
import 'package:squeak/features/mating/profile/domain/usecases/mating_profile_prams.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

abstract class BaseMatingPetProfileRepo {


  Future<Either<Failure, PetEntities>> getPetProfile(String petId);
  Future<Either<Failure, List<HistoryEntity>>> getPetHistory(String petId);


  Future<Either<Failure, void>> updatePetStatus(MatingProfileParams params);

}