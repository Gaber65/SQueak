import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../repositories/vaccination_repository.dart';

class DeleteReminderUseCase extends BaseUseCase<void, ReminderIdParams> {
  final VaccinationRepository repository;

  DeleteReminderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReminderIdParams params) {
    return repository.deleteReminder(params.id);
  }
}

class ReminderIdParams extends Equatable {
  final int id;

  const ReminderIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
