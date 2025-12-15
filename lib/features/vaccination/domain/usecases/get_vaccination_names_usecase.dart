import 'package:dartz/dartz.dart';

import '../../../../core/utils/export_path/export_files.dart';

import '../entities/vaccination_entity.dart';
import '../repositories/vaccination_repository.dart';

class GetVaccinationNamesUseCase
    extends BaseUseCase<List<VaccinationNameEntity>, NoParameters> {
  final VaccinationRepository repository;

  GetVaccinationNamesUseCase(this.repository);

  @override
  Future<Either<Failure, List<VaccinationNameEntity>>> call(
    NoParameters params,
  ) {
    return repository.getVaccinationNames();
  }
}
