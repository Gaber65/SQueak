import 'dart:convert';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../models/appointment_model.dart';
import '../models/clinic_model.dart';
import '../models/doctor_model.dart';
import '../models/availability_model.dart';

abstract class AppointmentLocalDataSource {
  Future<List<AppointmentModel>> getCachedAppointments();
  Future<void> cacheAppointments(List<AppointmentModel> appointments);
  Future<MySupplierModel?> getCachedSuppliers();
  Future<void> cacheSuppliers(MySupplierModel suppliers);
  Future<List<DoctorModel>?> getCachedDoctors(String clinicCode);
  Future<void> cacheDoctors(String clinicCode, List<DoctorModel> doctors);
  Future<List<AvailabilityModel>?> getCachedAvailabilities(String clinicCode);
  Future<void> cacheAvailabilities(String clinicCode, List<AvailabilityModel> availabilities);
  Future<void> clearCache(String key);
}

class AppointmentLocalDataSourceImpl implements AppointmentLocalDataSource {
  AppointmentLocalDataSourceImpl();

  @override
  Future<List<AppointmentModel>> getCachedAppointments() async {
    try {
      final jsonString = CacheHelper.getData('appointments');
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString);

        final list = List<AppointmentModel>.from(
          jsonMap.map((x) => AppointmentModel.fromJson(x)),
        );

        list.sort((a, b) => b.date.compareTo(a.date));

        return list;
      } else {
        throw LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        );
      }
    } catch (e) {
      throw LocalDatabaseFailure(
        ErrorMessageModel(
          message: 'No internet connection',
          statusCode: 0,
          errors: {},
          success: false,
        ),
      );
    }
  }


  @override
  Future<void> cacheAppointments(List<AppointmentModel> appointments) async {
    final jsonString = json.encode(
      appointments.map((appointment) => appointment.toJson()).toList(),
    );
    await CacheHelper.saveData('appointments', jsonString);
  }

  @override
  Future<MySupplierModel?> getCachedSuppliers() async {
    try {
      final jsonString = CacheHelper.getData('suppliers');
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString);
        return MySupplierModel.fromJson(jsonMap);
      } else {
        return null;
      }
    } catch (e) {
      throw LocalDatabaseFailure(
        ErrorMessageModel(
          message: 'No internet connection',
          statusCode: 0,
          errors: {},
          success: false,
        ),
      );
    }
  }

  @override
  Future<void> cacheSuppliers(MySupplierModel suppliers) async {
    final jsonString = json.encode(suppliers.toJson());
    await CacheHelper.saveData('suppliers', jsonString);
  }

  @override
  Future<List<DoctorModel>?> getCachedDoctors(String clinicCode) async {
    try {
      final jsonString = CacheHelper.getData('doctors_$clinicCode');
      if (jsonString != null) {
        final jsonList = json.decode(jsonString);
        return List<DoctorModel>.from(
          jsonList.map((x) => DoctorModel.fromJson(x)),
        );
      } else {
        return null;
      }
    } catch (e) {
      throw LocalDatabaseFailure(
        ErrorMessageModel(
          message: 'Failed to load cached doctors',
          statusCode: 0,
          errors: {},
          success: false,
        ),
      );
    }
  }

  @override
  Future<void> cacheDoctors(String clinicCode, List<DoctorModel> doctors) async {
    final jsonString = json.encode(doctors.map((doctor) => doctor.toJson()).toList());
    await CacheHelper.saveData('doctors_$clinicCode', jsonString);
  }

  @override
  Future<List<AvailabilityModel>?> getCachedAvailabilities(String clinicCode) async {
    try {
      final jsonString = CacheHelper.getData('availabilities_$clinicCode');
      if (jsonString != null) {
        final jsonList = json.decode(jsonString);
        return List<AvailabilityModel>.from(
          jsonList.map((x) => AvailabilityModel.fromJson(x)),
        );
      } else {
        return null;
      }
    } catch (e) {
      throw LocalDatabaseFailure(
        ErrorMessageModel(
          message: 'Failed to load cached availabilities',
          statusCode: 0,
          errors: {},
          success: false,
        ),
      );
    }
  }

  @override
  Future<void> cacheAvailabilities(String clinicCode, List<AvailabilityModel> availabilities) async {
    final jsonString = json.encode(availabilities.map((availability) => availability.toJson()).toList());
    await CacheHelper.saveData('availabilities_$clinicCode', jsonString);
  }

  @override
  Future<void> clearCache(String key) async {
    await CacheHelper.removeData(key);
  }
}
