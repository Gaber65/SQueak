import 'package:squeak/core/offline/offline_manager.dart';
import '../data_source/appointment_remote_data_source.dart';
import '../models/appointment_model.dart';
import '../models/availability_model.dart';
import '../models/doctor_model.dart';
import '../models/client_clinic_model.dart';
import '../models/invoice_model.dart';
import '../../domain/use_case/create_appointment.dart';
import 'package:flutter/foundation.dart';

/// Enhanced appointment repository with offline capabilities
class OfflineAppointmentRepository {
  final AppointmentRemoteDataSource _remoteDataSource;
  final OfflineManager _offlineManager;

  OfflineAppointmentRepository({
    required AppointmentRemoteDataSource remoteDataSource,
    OfflineManager? offlineManager,
  })  : _remoteDataSource = remoteDataSource,
        _offlineManager = offlineManager ?? OfflineManager();

  /// Get availabilities with offline support
  Future<List<AvailabilityModel>> getAvailabilities(String clinicCode) async {
    return await _offlineManager.getData<List<AvailabilityModel>>(
      key: 'availabilities_$clinicCode',
      onlineDataFetcher: () async {
        final availabilities = await _remoteDataSource.getAvailabilities(clinicCode);
        if (kDebugMode) {
          debugPrint('Fetched ${availabilities.length} availabilities for clinic $clinicCode');
        }
        return availabilities;
      },
      cacheTTL: const Duration(hours: 1), // Availabilities change frequently
    ) ?? [];
  }

  /// Get doctors with offline support
  Future<List<DoctorModel>> getDoctors(String clinicCode) async {
    return await _offlineManager.getData<List<DoctorModel>>(
      key: 'doctors_$clinicCode',
      onlineDataFetcher: () async {
        final doctors = await _remoteDataSource.getDoctors(clinicCode);
        if (kDebugMode) {
          debugPrint('Fetched ${doctors.length} doctors for clinic $clinicCode');
        }
        return doctors;
      },
      cacheTTL: const Duration(hours: 24), // Doctors change less frequently
    ) ?? [];
  }

  /// Get user appointments with offline support
  Future<List<AppointmentModel>> getUserAppointments(
    String phone,
    bool applyFilter,
  ) async {
    return await _offlineManager.getData<List<AppointmentModel>>(
      key: 'user_appointments_${phone}_$applyFilter',
      onlineDataFetcher: () async {
        final appointments = await _remoteDataSource.getUserAppointments(phone, applyFilter);
        if (kDebugMode) {
          debugPrint('Fetched ${appointments.length} appointments for user $phone');
        }
        return appointments;
      },
      cacheTTL: const Duration(minutes: 30), // Appointments change frequently
    ) ?? [];
  }

  /// Create appointment with offline queuing
  Future<void> createAppointment(CreateAppointmentParams params) async {
    if (_offlineManager.isOnline) {
      try {
        await _remoteDataSource.createAppointment(params);
        if (kDebugMode) {
          debugPrint('SUCCESS: Appointment created successfully');
        }
      } catch (e) {
        // Queue for offline sync
        await _queueAppointmentCreation(params);
        rethrow;
      }
    } else {
      // Queue for offline sync
      await _queueAppointmentCreation(params);
      if (kDebugMode) {
        debugPrint('Appointment queued for offline sync');
      }
    }
  }

  /// Delete appointment with offline queuing
  Future<void> deleteAppointment(String appointmentId) async {
    if (_offlineManager.isOnline) {
      try {
        await _remoteDataSource.deleteAppointment(appointmentId);
        if (kDebugMode) {
          debugPrint('Appointment deleted successfully');
        }
      } catch (e) {
        // Queue for offline sync
        await _queueAppointmentDeletion(appointmentId);
        rethrow;
      }
    } else {
      // Queue for offline sync
      await _queueAppointmentDeletion(appointmentId);
      if (kDebugMode) {
        debugPrint('Appointment deletion queued for offline sync');
      }
    }
  }

  /// Rate appointment with offline queuing
  Future<void> rateAppointment({
    required String appointmentId,
    required int cleanlinessRate,
    required int doctorServiceRate,
    required String feedbackComment,
  }) async {
    if (_offlineManager.isOnline) {
      try {
        await _remoteDataSource.rateAppointment(
          appointmentId: appointmentId,
          cleanlinessRate: cleanlinessRate,
          doctorServiceRate: doctorServiceRate,
          feedbackComment: feedbackComment,
        );
        if (kDebugMode) {
          debugPrint('SUCCESS: Appointment rated successfully');
        }
      } catch (e) {
        // Queue for offline sync
        await _queueAppointmentRating(
          appointmentId,
          cleanlinessRate,
          doctorServiceRate,
          feedbackComment,
        );
        rethrow;
      }
    } else {
      // Queue for offline sync
      await _queueAppointmentRating(
        appointmentId,
        cleanlinessRate,
        doctorServiceRate,
        feedbackComment,
      );
      if (kDebugMode) {
        debugPrint('Appointment rating queued for offline sync');
      }
    }
  }

  /// Get invoice with offline support
  Future<InvoiceModel?> getInvoice(String id) async {
    return await _offlineManager.getData<InvoiceModel>(
      key: 'invoice_$id',
      onlineDataFetcher: () async {
        final invoice = await _remoteDataSource.getInvoice(id);
        if (kDebugMode) {
          debugPrint('Fetched invoice for ID: $id');
        }
        return invoice;
      },
      cacheTTL: const Duration(days: 30), // Invoices don't change
    );
  }

  /// Get client clinics with offline support
  Future<List<PetClinicModel>> getClientInClinic(
    String clinicCode,
    String phone,
  ) async {
    return await _offlineManager.getData<List<PetClinicModel>>(
      key: 'client_clinic_${clinicCode}_$phone',
      onlineDataFetcher: () async {
        final clinics = await _remoteDataSource.getClientInClinic(clinicCode, phone);
        if (kDebugMode) {
          debugPrint('Fetched ${clinics.length} client clinics');
        }
        return clinics;
      },
      cacheTTL: const Duration(hours: 6), // Client clinic data changes moderately
    ) ?? [];
  }

  /// Queue appointment creation for offline sync
  Future<void> _queueAppointmentCreation(CreateAppointmentParams params) async {
    final operation = OfflineOperation(
      id: 'create_appointment_${DateTime.now().millisecondsSinceEpoch}',
      type: 'create_appointment',
      data: {
        'petId': params.petId,
        'doctorId': params.doctorId,
        'clinicCode': params.clinicCode,
        'appointmentTime': params.appointmentTime,
        'appointmentDate': params.appointmentDate,
        'petGender': params.petGender,
        'petName': params.petName,
        'clientId': params.clientId,
        'petSqueakId': params.petSqueakId,
        'specieId': params.specieId,
        'breedId': params.breedId,
        'isSpayed': params.isSpayed,
        'notes': params.notes,
        'isExisted': params.isExisted,
        'notExistedOrPet': params.notExistedOrPet,
        'isExistedNoPet': params.isExistedNoPet,
      },
    );
    
    await _offlineManager.queueOperation(operation);
  }

  /// Queue appointment deletion for offline sync
  Future<void> _queueAppointmentDeletion(String appointmentId) async {
    final operation = OfflineOperation(
      id: 'delete_appointment_${DateTime.now().millisecondsSinceEpoch}',
      type: 'delete_appointment',
      data: {
        'appointmentId': appointmentId,
      },
    );
    
    await _offlineManager.queueOperation(operation);
  }

  /// Queue appointment rating for offline sync
  Future<void> _queueAppointmentRating(
    String appointmentId,
    int cleanlinessRate,
    int doctorServiceRate,
    String feedbackComment,
  ) async {
    final operation = OfflineOperation(
      id: 'rate_appointment_${DateTime.now().millisecondsSinceEpoch}',
      type: 'rate_appointment',
      data: {
        'appointmentId': appointmentId,
        'cleanlinessRate': cleanlinessRate,
        'doctorServiceRate': doctorServiceRate,
        'feedbackComment': feedbackComment,
      },
    );
    
    await _offlineManager.queueOperation(operation);
  }

  /// Get offline status for appointments
  OfflineStatus getOfflineStatus() {
    return _offlineManager.getStatus();
  }

  /// Force sync all queued operations
  Future<void> forceSyncOperations() async {
    await _offlineManager.forcSync();
  }
}
