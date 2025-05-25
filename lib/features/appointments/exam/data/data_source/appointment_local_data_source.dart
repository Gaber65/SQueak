import 'dart:convert';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../models/appointment_model.dart';
import '../models/clinic_model.dart';

abstract class AppointmentLocalDataSource {
  Future<List<AppointmentModel>> getCachedAppointments();
  Future<void> cacheAppointments(List<AppointmentModel> appointments);
  Future<MySupplierModel?> getCachedSuppliers();
  Future<void> cacheSuppliers(MySupplierModel suppliers);
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
        return List<AppointmentModel>.from(
          jsonMap.map((x) => AppointmentModel.fromJson(x)),
        );
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
  Future<void> clearCache(String key) async {
    await CacheHelper.removeData(key);
  }
}
