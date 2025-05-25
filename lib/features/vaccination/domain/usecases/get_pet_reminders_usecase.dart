import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/export_path/export_files.dart';

import '../entities/reminder_entity.dart';
import '../repositories/vaccination_repository.dart';

class GetPetRemindersUseCase extends BaseUseCase<List<ReminderEntity>, PetIdParams> {
  final VaccinationRepository repository;

  GetPetRemindersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReminderEntity>>> call(PetIdParams params) {
    return repository.getPetReminders(params.petId);
  }
}

class PetIdParams extends Equatable {
  final String petId;

  const PetIdParams({required this.petId});

  @override
  List<Object> get props => [petId];
}
