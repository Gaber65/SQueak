import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/vaccination_entity.dart';
import '../entities/reminder_entity.dart';

abstract class VaccinationRepository {
  Future<Either<Failure, List<VaccinationNameEntity>>> getVaccinationNames();
  Future<Either<Failure, List<ReminderEntity>>> getPetReminders(String petId);
  Future<Either<Failure, void>> createReminder(ReminderEntity reminder);
  Future<Either<Failure, void>> updateReminder(ReminderEntity reminder);
  Future<Either<Failure, void>> deleteReminder(int id);
}
