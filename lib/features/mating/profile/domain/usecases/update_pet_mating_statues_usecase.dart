import 'package:dartz/dartz.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/features/mating/profile/domain/usecases/mating_profile_prams.dart';

import '../../../../../core/error/failure.dart';
import '../repo/base_mating_pet_profile_repo.dart';

class UpdatePetMatingStatuesUseCase implements BaseUseCase<void, MatingProfileParams> {
  final BaseMatingPetProfileRepo baseMatingPetProfileRepo;

  UpdatePetMatingStatuesUseCase(this.baseMatingPetProfileRepo);

  @override
  Future<Either<Failure, void>> call(MatingProfileParams params) {
    return baseMatingPetProfileRepo.updatePetStatus(params);
  }
}
