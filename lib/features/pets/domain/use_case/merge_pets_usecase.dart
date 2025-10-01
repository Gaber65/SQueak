import 'package:dartz/dartz.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/pet_entity.dart';

class MergePetsUsecase extends BaseUseCase<PetEntities, List<String>> {
  final PetRepository repository;
  MergePetsUsecase(this.repository);

  @override
  Future<Either<Failure, PetEntities>> call(List<String> ids) async {
    return await repository.mergePets(ids);
  }
}
