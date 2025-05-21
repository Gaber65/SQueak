import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/pet_base_repository.dart';
import '../entities/pet_entity.dart';

class CreatePetUseCase extends BaseUseCase<PetEntities, PetParams> {
  final PetRepository repository;

  CreatePetUseCase(this.repository);

  @override
  Future<Either<Failure, PetEntities>> call(PetParams parameters) {
    return repository.createPet(parameters.pet);
  }
}

class PetParams extends Equatable {
  final PetEntities pet;

  const PetParams({required this.pet});

  @override
  List<Object> get props => [pet];
}