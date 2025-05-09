import 'package:dio/dio.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentData>> getAllAppointments();
  Future<List<AppointmentData>> getAppointmentsByStatus(int status);
  Future<AppointmentData> getAppointmentById(String id);
  Future<AppointmentData> createAppointment(AppointmentData appointment);
  Future<AppointmentData> updateAppointment(AppointmentData appointment);
  Future<void> deleteAppointment(String id);
  Future<void> checkInPet(String appointmentId, bool isCheckedIn);
  Future<List<DoctorData>> getClinicDoctors(String clinicId);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  @override
  Future<List<AppointmentData>> getAllAppointments() async {
    try {
      final response = await DioFinalHelper.getData(
        method: getAllAppointmentsEndpoint,
        language: true,
      );
      return (response.data['data']['appointments'] as List)
          .map((e) => AppointmentData.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<AppointmentData>> getAppointmentsByStatus(int status) async {
    try {
      final response = await DioFinalHelper.getData(
        method: '$getAppointmentsByStatusEndpoint/$status',
        language: true,
      );
      return (response.data['data']['appointments'] as List)
          .map((e) => AppointmentData.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<AppointmentData> getAppointmentById(String id) async {
    try {
      final response = await DioFinalHelper.getData(
        method: '$getAppointmentByIdEndpoint/$id',
        language: true,
      );
      return AppointmentData.fromJson(response.data['data']['appointment']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<AppointmentData> createAppointment(AppointmentData appointment) async {
    try {
      final response = await DioFinalHelper.postData(
        method: createAppointmentEndpoint,
        data: appointment.toJson(),
      );
      return AppointmentData.fromJson(response.data['data']['appointment']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<AppointmentData> updateAppointment(AppointmentData appointment) async {
    try {
      final response = await DioFinalHelper.patchData(
        method: '$updateAppointmentEndpoint/${appointment.id}',
        data: appointment.toJson(),
      );
      return AppointmentData.fromJson(response.data['data']['appointment']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    try {
      await DioFinalHelper.deleteData(
        method: '$deleteAppointmentEndpoint/$id',
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> checkInPet(String appointmentId, bool isCheckedIn) async {
    try {
      await DioFinalHelper.patchData(
        method: '$checkInPetEndpoint/$appointmentId',
        data: {'isPetCheckIn': isCheckedIn},
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<DoctorData>> getClinicDoctors(String clinicId) async {
    try {
      final response = await DioFinalHelper.getData(
        method: '$getClinicDoctorsEndpoint/$clinicId',
        language: true,
      );
      return (response.data['data']['doctors'] as List)
          .map((e) => DoctorData.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
} 