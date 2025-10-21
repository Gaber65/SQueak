import 'package:dartz/dartz.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/features/mating/profile/domain/entities/history_entities.dart';
import 'package:squeak/features/mating/profile/domain/repo/base_mating_pet_profile_repo.dart';

import '../../../../../core/error/failure.dart';

class GetPetHistoryMatingUseCase
    implements BaseUseCase<List<HistoryEntity>, String> {
  final BaseMatingPetProfileRepo repository;

  GetPetHistoryMatingUseCase(this.repository);

  @override
  Future<Either<Failure, List<HistoryEntity>>> call(String petId) async {
    return await repository.getPetHistory(petId);
  }
}
