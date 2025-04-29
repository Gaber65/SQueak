import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/pet_base_repository.dart';

class DeletePetUseCase extends BaseUseCase<void, String> {
  final PetRepository repository;

  DeletePetUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deletePet(id);
  }
}
