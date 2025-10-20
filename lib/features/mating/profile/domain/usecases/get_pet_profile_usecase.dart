import 'package:dartz/dartz.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/features/mating/profile/domain/repo/base_mating_pet_profile_repo.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../core/error/failure.dart';

class GetPetProfileMatingUseCase implements BaseUseCase<PetEntities, String> {
  final BaseMatingPetProfileRepo repository;

  GetPetProfileMatingUseCase(this.repository);

  @override
  Future<Either<Failure, PetEntities>> call(String petId) async {
    return await repository.getPetProfile(petId);
  }
}
