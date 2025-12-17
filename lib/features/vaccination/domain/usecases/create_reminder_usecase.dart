import 'package:dartz/dartz.dart';
import 'package:squeak/features/vaccination/domain/usecases/update_reminder_usecase.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../repositories/vaccination_repository.dart';

class CreateReminderUseCase extends BaseUseCase<void, ReminderParams> {
  final VaccinationRepository repository;

  CreateReminderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReminderParams params) {
    return repository.createReminder(params.reminder);
  }
}
