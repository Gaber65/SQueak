import '../../../../core/error/exception.dart';
import '../../../../core/service/cache/local_database/local_database.dart';
import '../models/reminder_model.dart';

abstract class VaccinationLocalDataSource {
  Future<List<ReminderModel>> getPetReminders(String petId);
  Future<void> createReminder(ReminderModel reminder);
  Future<void> updateReminder(ReminderModel reminder);
  Future<void> deleteReminder(int id);
}

class VaccinationLocalDataSourceImpl implements VaccinationLocalDataSource {
  VaccinationLocalDataSourceImpl();

  @override
  Future<List<ReminderModel>> getPetReminders(String petId) async {
    try {
      final reminders = await LocalDatabaseHelper.getAllReminders(
        petId: petId,
      );
      return reminders;
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> createReminder(ReminderModel reminder) async {
    try {

      await LocalDatabaseHelper.insertReminder(reminder);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await LocalDatabaseHelper.updateReminder(reminder);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> deleteReminder(int id) async {
    try {
      await LocalDatabaseHelper.deleteReminder(id);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }
}

