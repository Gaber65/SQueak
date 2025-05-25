import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:printing/printing.dart';

import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';

import 'package:squeak/features/appointments/exam/presentation/view/appointments/print_reciept.dart';
import 'dart:typed_data';
import '../../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/invoice.dart';

part 'user_appointment_state.dart';

class UserAppointmentCubit extends Cubit<UserAppointmentState> {
  final GetUserAppointmentsUseCase getUserAppointments;
  final DeleteAppointmentUseCase deleteAppointment;
  final RateAppointmentUseCase rateAppointment;
  final GetSuppliersUseCase getSuppliers;
  final FollowClinicUseCase followClinic;
  final GetInvoiceUseCase getInvoice;

  UserAppointmentCubit({
    required this.getUserAppointments,
    required this.deleteAppointment,
    required this.rateAppointment,
    required this.getSuppliers,
    required this.followClinic,
    required this.getInvoice,
  }) : super(UserAppointmentInitial());

  static UserAppointmentCubit get(context) => BlocProvider.of(context);

  List<AppointmentEntity> appointments = [];
  MySupplier? suppliers;
  Invoice? invoice;
  PetPrint? pet;
  OwnerPrint? owner;
  bool isLoadingInvoice = false;
  List<AppointmentEntity> filteredList = [];
  String? selectedPetId;
  String? petName;
  int? selectedState;
  String? selectedStateValue;
  int ratingCleanliness = 0;
  int ratingDoctor = 0;
  TextEditingController rateController = TextEditingController();
  bool isLoadingRate = false;

  Future<void> getAppointment(bool applyFilter) async {
    emit(GetAppointmentLoading());
    final result = await getUserAppointments(
      GetUserAppointmentsParams(
        phone: CacheHelper.getData('phone'),
        applyFilter: applyFilter,
      ),
    );
    result.fold((failure) => emit(GetAppointmentError()), (appointmentsList) {
      appointments = appointmentsList;

      filteredList = List.from(appointments);
      emit(GetAppointmentSuccess());
    });
  }

  Future<void> deleteAppointments(String appointmentId) async {
    emit(DeleteAppointmentLoading());
    final result = await deleteAppointment(
      DeleteAppointmentParams(appointmentId: appointmentId),
    );
    result.fold(
      (failure) => emit(DeleteAppointmentError()),
      (_) => emit(DeleteAppointmentSuccess(appointmentId)),
    );
  }

  Future<void> rateUserAppointment(AppointmentEntity model) async {
    isLoadingRate = true;
    emit(RateAppointmentLoading());
    final result = await rateAppointment(
      RateAppointmentParams(
        appointmentId: model.id,
        cleanlinessRate: ratingCleanliness,
        doctorServiceRate: ratingDoctor,
        feedbackComment: model.feedbackComment ?? '',
      ),
    );
    isLoadingRate = false;
    result.fold(
      (failure) => emit(RateAppointmentError()),
      (_) => emit(RateAppointmentSuccess()),
    );
  }

  Future<void> fetchSuppliers() async {
    emit(GetSupplierLoading());
    final result = await getSuppliers(const NoParameters());
    result.fold((failure) => emit(GetSupplierError()), (suppliersData) {
      suppliers = suppliersData;
      emit(GetSupplierSuccess());
    });
  }

  Future<void> followClinicById(String clinicId) async {
    emit(FollowLoading());
    final result = await followClinic(clinicId);
    result.fold((failure) => emit(FollowError()), (_) => emit(FollowSuccess()));
  }

  Future<void> fetchInvoice(String id) async {
    isLoadingInvoice = true;
    emit(GetInvoicesLoading());
    final result = await getInvoice(GetInvoiceParams(id: id));
    isLoadingInvoice = false;
    result.fold(
      (failure) => emit(GetInvoicesError(extractFirstError(failure))),
      (invoiceData) {
        invoice = invoiceData;

        // Create pet and owner models from invoice data
        pet = PetPrint(
          petName: invoiceData.petName,
          species: invoiceData.species,
          sex: invoiceData.sex,
        );

        owner = OwnerPrint(
          ownerName: invoiceData.ownerName,
          phone: invoiceData.clientPhone,
        );

        emit(GetInvoicesSuccess());
      },
    );
  }

  void filterAppointments({
    String? petId,
    String? petName,
    int? state,
    String? stateValue,
  }) {
    selectedPetId = petId;
    selectedState = state;
    this.petName = petName;
    selectedStateValue = stateValue;

    filteredList =
        appointments.where((appointment) {
          final matchesPet =
              selectedPetId == null ||
              appointment.pet.squeakPetId == selectedPetId;
          final matchesState =
              selectedState == null || appointment.status == selectedState;
          return matchesPet && matchesState;
        }).toList();

    emit(AppointmentFiltered(filteredList));
  }

  void clearFilters() {
    selectedPetId = null;
    selectedState = null;
    selectedStateValue = null;
    petName = null;
    filteredList = List.from(appointments);
    emit(AppointmentFilterCleared());
  }

  void initRating(AppointmentEntity appointment) {
    ratingCleanliness = appointment.cleanlinessRate;
    ratingDoctor = appointment.doctorServiceRate;
    rateController.text = appointment.feedbackComment ?? '';
    emit(RatingInitialized());
  }

  Future<void> printPdf(Uint8List pdfData) async {
    try {
      await Printing.layoutPdf(
        onLayout: (format) {
          return pdfData;
        },
      );
    } catch (e) {
      // Handle printing error
    }
  }

  ClinicInfo? findClinic(
    List<ClinicInfo> data,
    String clinicCode,
    String clinicId,
  ) {
    for (var element in data) {
      if (element.data.code == clinicCode) {
        return element;
      }
    }
    // If clinic not found, follow it
    followClinicById(clinicId);
    return null;
  }

  void printReceipt(AppointmentEntity model, context) async {
    navigateToScreen(
      context,

      PrintScreen(
        id: model.id,

        clinicPhone: model.clinicPhone,

        clinicImage: model.clinicLogo ?? '',
      ),
    );
  }
}
