import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:squeak/core/utils/enums/day_of_week_enum.dart';
import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/exam/domain/entities/client_clinic.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';

import '../../../../../../../core/service/service_locator/locatore_export_path.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final GetAvailabilitiesUseCase getAvailabilitiesUseCase;
  final GetSuppliersUseCase getSuppliersUseCase;
  final UnfollowClinicUseCase unfollowClinicUseCase;
  final GetDoctorsUseCase getDoctorsUseCase;
  final GetClientInClinicUseCase getClientInClinicUseCase;
  final CreateAppointmentUseCase createAppointmentUseCase;
  final FollowClinicUseCase followClinicUseCase;

  AppointmentCubit({
    required this.getAvailabilitiesUseCase,
    required this.getSuppliersUseCase,
    required this.unfollowClinicUseCase,
    required this.getDoctorsUseCase,
    required this.getClientInClinicUseCase,
    required this.createAppointmentUseCase,
    required this.followClinicUseCase,
  }) : super(AppointmentInitial());

  static AppointmentCubit get(context) => BlocProvider.of(context);
  List<Availability> availabilities = [];
  TextEditingController commentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController time = TextEditingController();
  Availability? selectedTime;
  List<TimeOfDay> timeSlots = [];
  TimeOfDay? selectedTimeSlot;
  DateTime? selectedDate;
  bool isNoSelect = false;
  MySupplier? suppliers;
  List<ClinicInfo> filteredSuppliers = [];
  List<Doctor> doctors = [];
  bool clientInClinic = false;
  List<PetClinic> petListInVet = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  void initialize() {
    getSuppliersList();
  }

  // New method to load both availabilities and doctors in parallel
  Future<void> loadAvailabilityPageData(String clinicCode) async {
    final availabilityFuture = fetchAvailabilities(clinicCode);
    final doctorsFuture = fetchDoctors(clinicCode);
    await Future.wait([availabilityFuture, doctorsFuture]);
  }

  Future<void> fetchAvailabilities(String clinicCode) async {
    emit(GetAvailabilityLoading());
    final result = await getAvailabilitiesUseCase(
      GetAvailabilitiesParams(clinicCode: clinicCode),
    );
    result.fold((failure) => emit(GetAvailabilityError()), (
      availabilitiesList,
    ) {
      availabilities = _removeDuplicatesByDayOfWeek(availabilitiesList);
      emit(GetAvailabilitySuccess());
    });
  }

  List<Availability> _removeDuplicatesByDayOfWeek(
    List<Availability> availabilityList,
  ) {
    final uniqueDays = <DayOfWeek>{};
    return availabilityList.where((availability) {
      if (uniqueDays.contains(availability.dayOfWeek)) {
        return false;
      } else {
        uniqueDays.add(availability.dayOfWeek);
        return true;
      }
    }).toList();
  }

  Future<void> getSuppliersList() async {
    emit(GetSupplierLoadingScreen());
    final result = await getSuppliersUseCase(const NoParameters());
    result.fold((failure) => emit(GetSupplierErrorScreen()), (suppliersData) {
      suppliers = suppliersData;
      filteredSuppliers = suppliersData.data;
      emit(GetSupplierSuccessScreen());
    });
  }

  Future<void> unfollowClinicById(String clinicId, {ClinicInfo? clinic}) async {
    emit(UnFollowLoading());
    final result = await unfollowClinicUseCase(clinicId);
    result.fold(
      (failure) => emit(UnFollowError()),
      (_) => emit(UnFollowSuccess(clinic!)),
    );
  }

  Future<void> fetchDoctors(String clinicCode) async {
    emit(GetDoctorLoading());
    final result = await getDoctorsUseCase(
      GetDoctorsParams(clinicCode: clinicCode),
    );
    result.fold((failure) => emit(GetDoctorError()), (doctorsList) {
      doctors = doctorsList;
      emit(GetDoctorSuccess());
    });
  }

  Future<void> getClientINClinic(String clinicCode) async {
    emit(GetClientInClinicLoading());
    final result = await getClientInClinicUseCase(
      GetClientInClinicParams(
        clinicCode: clinicCode,
        phone: CacheHelper.getData('phone'),
      ),
    );
    result.fold(
      (failure) {
        emit(GetClientInClinicError());
      },
      (clientClinicList) {
        clientInClinic = clientClinicList.isNotEmpty;


        petListInVet = clientClinicList;
        emit(GetClientInClinicSuccess());
      },
    );
  }

  Future<void> createNewAppointment(CreateAppointmentParams params) async {
    isLoading = true;
    emit(CreateAppointmentsLoading());

    final result = await createAppointmentUseCase(params);

    isLoading = false;
    result.fold(
      (failure) {
        emit(CreateAppointmentsError(extractFirstError(failure)));
      },
      (_) {
        if (params.isExisted) {
          emit(CreateExistedClientAppointment());
        } else if (params.isExistedNoPet) {
          emit(CreateNewPetAppointment());
        } else if (params.notExistedOrPet) {
          emit(CreateNewPetAndClientAppointment());
        }
        emit(CreateAppointmentsSuccess());
      },
    );
  }

  void selectTime(Availability availability) {
    selectedTime = availability;
    emit(TimeSelected());
  }

  void filterSuppliers(String query) {
    if (suppliers != null) {
      if (query.isEmpty) {
        // If query is empty, show all suppliers
        filteredSuppliers = List.from(
          suppliers!.data,
        ); // Create a new list instance
      } else {
        // Filter by name OR code (case insensitive)
        filteredSuppliers =
            suppliers!.data.where((supplier) {
              final name = supplier.data.name.toLowerCase();
              final code = supplier.data.code.toLowerCase();
              final lowerQuery = query.toLowerCase();

              return name.contains(lowerQuery) || code.contains(lowerQuery);
            }).toList();
      }
      emit(SuppliersFilteredScreen()); // Only emit once
    }
  }

  void setNoSelect(bool error) {
    isNoSelect = error;
    emit(NoSelectState());
  }

  @override
  Future<void> close() {
    // Dispose controllers to prevent memory/resource leaks
    commentController.dispose();
    dateController.dispose();
    time.dispose();
    searchController.dispose();
    return super.close();
  }
}
