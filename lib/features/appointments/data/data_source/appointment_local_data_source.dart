import 'dart:convert';
import '../../../../core/utils/export_path/export_files.dart';
import '../models/appointment_model.dart';

abstract class AppointmentLocalDataSource {
  Future<List<AppointmentData>> getCachedAppointments();
  Future<void> cacheAppointments(List<AppointmentData> appointments);
  Future<List<DoctorData>> getCachedDoctors();
  Future<void> cacheDoctors(List<DoctorData> doctors);
}

class AppointmentLocalDataSourceImpl implements AppointmentLocalDataSource {
  @override
  Future<List<AppointmentData>> getCachedAppointments() async {
    try {
      final jsonString = CacheHelper.getData('userAppointments');
      if (jsonString != null) {
        return List<AppointmentData>.from(
          json.decode(jsonString).map((x) => AppointmentData.fromJson(x)),
        );
      }
      return [];
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> cacheAppointments(List<AppointmentData> appointments) async {
    try {
      final jsonString = json.encode(
        appointments.map((appointment) => appointment.toJson()).toList(),
      );
      await CacheHelper.saveData('userAppointments', jsonString);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<DoctorData>> getCachedDoctors() async {
    try {
      final jsonString = CacheHelper.getData('clinicDoctors');
      if (jsonString != null) {
        return List<DoctorData>.from(
          json.decode(jsonString).map((x) => DoctorData.fromJson(x)),
        );
      }
      return [];
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> cacheDoctors(List<DoctorData> doctors) async {
    try {
      final jsonString = json.encode(
        doctors.map((doctor) => doctor.toJson()).toList(),
      );
      await CacheHelper.saveData('clinicDoctors', jsonString);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }
} 