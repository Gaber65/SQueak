import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/export_path/export_files.dart';

import '../entities/reminder_entity.dart';
import '../repositories/vaccination_repository.dart';

class UpdateReminderUseCase extends BaseUseCase<void, ReminderParams> {
  final VaccinationRepository repository;

  UpdateReminderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReminderParams params) {
    return repository.updateReminder(params.reminder);
  }
}

class ReminderParams extends Equatable {
  final ReminderEntity reminder;

  const ReminderParams({required this.reminder});

  @override
  List<Object> get props => [reminder];
}
