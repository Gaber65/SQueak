import 'package:dio/dio.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/core/network/end-points.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/network/error_message_model.dart';
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
      final reminders = await LocalDatabaseHelper.getAllReminders(petId: petId);
      return reminders;
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> createReminder(ReminderModel reminder) async {
    try {
      await LocalDatabaseHelper.insertReminder(reminder);

      addReminderToServer(reminder);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  Future<void> addReminderToServer(ReminderModel reminder) async {
    try {
      await DioFinalHelper.postData(
        method: petVacEndPoint,
        data: {
          'petId': reminder.petId,
          'vaccinationId': reminder.vaccinationId,
          'vacDate': reminder.date,
          'status': false,
          'comment': reminder.notes,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
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
