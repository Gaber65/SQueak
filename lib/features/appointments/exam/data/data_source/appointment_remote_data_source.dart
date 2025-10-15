import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../models/appointment_model.dart';
import '../models/availability_model.dart';
import '../models/client_clinic_model.dart';
import '../models/clinic_model.dart';
import '../models/doctor_model.dart';
import '../models/invoice_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AvailabilityModel>> getAvailabilities(String clinicCode);
  Future<MySupplierModel> getSuppliers();
  Future<List<DoctorModel>> getDoctors(String clinicCode);
  Future<List<PetClinicModel>> getClientInClinic(
    String clinicCode,
    String phone,
  );
  Future<void> createAppointment(CreateAppointmentParams prams);
  Future<List<AppointmentModel>> getUserAppointments(
    String phone,
    bool applyFilter,
  );
  Future<void> deleteAppointment(String appointmentId);
  Future<void> rateAppointment({
    required String appointmentId,
    required int cleanlinessRate,
    required int doctorServiceRate,
    required String feedbackComment,
  });
  Future<InvoiceModel> getInvoice(String id);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {


  @override
  Future<List<AvailabilityModel>> getAvailabilities(String clinicCode) async {

    try {
      final response = await DioFinalHelper.getData(
        method: getAvailabilitiesEndPoint(clinicCode),
        language: true,
      );


      final List data = response.data['data'];
      return data
          .map((e) => AvailabilityModel.fromJson(e))
          .where((e) => e.isActive == true)
          .toList()
          .cast<AvailabilityModel>();
    } on DioException catch (e) {


      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<MySupplierModel> getSuppliers() async {
    try {
      final response = await DioFinalHelper.getData(
        method: getFollowerClinicEndPoint,
        language: true,
      );
      return MySupplierModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<DoctorModel>> getDoctors(String clinicCode) async {
    try {
      final response = await DioFinalHelper.getData(
        method: getDoctorAppointmentsEndPoint(clinicCode),
        language: true,
      );
      return (response.data['data'] as List)
          .map((e) => DoctorModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<PetClinicModel>> getClientInClinic(
    String clinicCode,
    String phone,
  ) async {
    try {
      final response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(clinicCode, phone),
        language: true,
      );
      return (response.data['data'] as List)
          .map((e) => PetClinicModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      // print('***********error**********');
      // print('***********error**********');

      // print(e.response!.data);
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> createAppointment(CreateAppointmentParams params) async {
    try {
      String formattedTime = _formatAppointmentTime(params.appointmentTime);
      formattedTime = convertLocalTimeToUTC(formattedTime);
      if (params.isExisted) {
        final Map<String, dynamic> requestData = {
          "date": params.appointmentDate,
          "time": formattedTime,
          "petId": params.petId,
          "clinicCode": params.clinicCode,
          "clientId": params.clientId,
          "petSqueakId": params.petSqueakId,
          "squeakClientId": await _getClientId(),
          if (params.doctorId != null && params.doctorId!.isNotEmpty)
            "doctorUserId": params.doctorId,
          if (params.notes != null && params.notes!.isNotEmpty)
            "notes": params.notes,
        };

        try {
          await DioFinalHelper.postData(
            method: '$version/vetcare/reservation/existedClient',
            data: requestData,
          );
        } catch (_) {
          final swappedData = Map<String, dynamic>.from(requestData);
          final tempId = swappedData['petId'];
          swappedData['petId'] = swappedData['petSqueakId'];
          swappedData['petSqueakId'] = tempId;

          await DioFinalHelper.postData(
            method: '$version/vetcare/reservation/existedClient',
            data: swappedData,
          );
        }
      } else if (params.isExistedNoPet) {
        await DioFinalHelper.postData(
          method: '$version/vetcare/reservation/newPet',
          data: {
            "date": params.appointmentDate,
            "time": formattedTime,
            "clinicCode": params.clinicCode,
            "clientId": params.clientId,
            "doctorUserId": params.doctorId,
            "pet": {
              "petName": params.petName,
              "petGender": params.petGender,
              "isSpayed": params.isSpayed,
              "breedId": null,
              "specieId": null,
            },
            "squeakPetId": params.petSqueakId,
            "notes": params.notes,
          },
        );
      } else if (params.notExistedOrPet) {
        await DioFinalHelper.postData(
          method: '$version/vetcare/reservation/newPet/newClient',
          data: {
            "date": params.appointmentDate,
            "time": formattedTime,
            "clinicCode": params.clinicCode,
            "doctorUserId": params.doctorId,
            "pet": {
              "petName": params.petName,
              "petGender": params.petGender,
              "squeakPetId": params.petSqueakId,
              "isSpayed": params.isSpayed,
              "breedId": params.breedId == '' ? null : params.breedId,
              "specieId": params.specieId == '' ? null : params.specieId,
            },
            "client": {
              "name": await _getClientName(),
              "squeakClientId": await _getClientId(),
              "countryId": await _getCountryId(),
              "phone": await _getPhone(),
              "gender": 1,
            },
            "notes": params.notes,
          },
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  String _formatAppointmentTime(String time) {
    if (!time.contains(':')) return "$time:00:00";
    if (time.split(':').length == 2) return "$time:00";
    return time;
  }

  Future<String> _getClientId() async => CacheHelper.getData('clintId') ?? '';
  Future<String> _getClientName() async =>
      CacheHelper.getData('clientName') ?? '';
  Future<int> _getCountryId() async => CacheHelper.getData('countryId') ?? 1;
  Future<String> _getPhone() async => CacheHelper.getData('phone') ?? '';

  @override
  Future<List<AppointmentModel>> getUserAppointments(
    String phone,
    bool applyFilter,
  ) async {
    try {
      final endpoint = createAndGetAppointmentsEndPoint(phone, applyFilter);
      if (kDebugMode) {
        // Log the request endpoint and timestamp
        debugPrint('🛰️ ➜ [${DateTime.now().toIso8601String()}] Requesting user appointments: $endpoint');
      }

      final requestStart = DateTime.now();
      final response = await DioFinalHelper.getData(
        method: endpoint,
        language: true,
      );
      final requestEnd = DateTime.now();
      if (kDebugMode) {
        debugPrint('🛰️ ← [${requestEnd.toIso8601String()}] Response received for $endpoint (duration: ${requestEnd.difference(requestStart).inMilliseconds} ms)');
      }

      if (kDebugMode) {
        try {
          final data = response.data;
          // Log brief response info (size and keys). Avoid huge prints.
          final keys = data is Map ? data.keys.toList() : ['non-map-response'];
          debugPrint('✅ ← Response received for appointments (${keys.length} keys)');
        } catch (e) {
          debugPrint('⚠️ ← Response received but failed to parse debug info: $e');
        }
      }

      List<AppointmentModel> appointments =
          (response.data['data']['result'] as List)
              .map((e) => AppointmentModel.fromJson(e))
              .toList();

      appointments.sort((a, b) => b.date.compareTo(a.date));

      return appointments;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await DioFinalHelper.postData(
        method: deleteAppointmentsEndPoint,
        data: {"reservationId": appointmentId},
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> rateAppointment({
    required String appointmentId,
    required int cleanlinessRate,
    required int doctorServiceRate,
    required String feedbackComment,
  }) async {
    try {
      await DioFinalHelper.postData(
        method: rateAppointmentEndPoint,
        data: {
          "reservationId": appointmentId,
          "cleanlinessRate": cleanlinessRate,
          "doctorServiceRate": doctorServiceRate,
          "feedbackComment": feedbackComment,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<InvoiceModel> getInvoice(String id) async {
    try {
      final response = await DioFinalHelper.getData(
        method: invoiveEndPoint + id,
        language: true,
      );
      return InvoiceModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
