import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../layout/layout/data/models/clinic_model.dart';
import '../../../data/models/availabilities_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/models/get_client_clinic_model.dart';
import 'appointment_state.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  static AppointmentCubit get(context) =>
      BlocProvider.of<AppointmentCubit>(context);

  void init() {
    if (CacheHelper.getData('suppliers') != null) {
      String stringToJason = CacheHelper.getData('suppliers')!;
      var jsonToMap = json.decode(stringToJason);
      suppliers = MySupplierModel.fromJson(jsonToMap);
      filteredSuppliers = suppliers!.data;
      emit(GetSupplierSuccess());
    }
    getSupplier();
  }

  List<AvailabilityModel> availabilities = [];

  TextEditingController commentController = TextEditingController();

  AvailabilityModel? selectedTime;
  List<TimeOfDay> timeSlots = [];
  TimeOfDay? selectedTimeSlot;

  DateTime? selectedDate;
  bool isLoadingAvailability = false;
  Future<void> getAvailability(ClinicCode) async {
    isLoadingAvailability = true;
    emit(GetAvailabilityLoading());

    try {
      Response response = await DioFinalHelper.getData(
        method: getAvailabilitiesEndPoint(ClinicCode),
        language: false,
      );

      availabilities = removeDuplicatesByDayOfWeek(
        (response.data['data'] as List)
            .map((e) => AvailabilityModel.fromJson(e))
            .toList(),
      );

      availabilities =
          availabilities.where((element) => element.isActive == true).toList();
      availabilities.forEach((element) {
        print(element.toJson());
      });
      isLoadingAvailability = false;
      emit(GetAvailabilitySuccess());
    } on DioException catch (e) {
      print(e);
      isLoadingAvailability = false;
      emit(GetAvailabilityError());
    }
  }

  List<AvailabilityModel> removeDuplicatesByDayOfWeek(
      List<AvailabilityModel> availabilityList) {
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

  MySupplierModel? suppliers;
  List<ClinicInfo> filteredSuppliers = [];

  Future<void> getSupplier() async {
    emit(GetSupplierLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method: getFollowerClinicEndPoint,
        language: false,
      );
      print(response.data);
      CacheHelper.removeData('suppliers');

      String jasonToString = json.encode(response.data['data']);
      CacheHelper.saveData('suppliers', jasonToString);
      suppliers = MySupplierModel.fromJson(response.data['data']);
      filteredSuppliers = suppliers!.data;
      emit(GetSupplierSuccess());
    } on DioException catch (e) {
      print(e);
      emit(GetSupplierError());
    }
  }

  TextEditingController searchController = TextEditingController();

  void filterSuppliers(String query) {
    filteredSuppliers = suppliers!.data
        .where((supplier) =>
            supplier.data.name.toLowerCase().contains(query.toLowerCase()) ||
            supplier.data.code.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(GetSupplierSuccess());
  }

  Future unFollow(ClinicId) async {
    emit(UnFollowLoading());
    try {
      Response response = await DioFinalHelper.postData(
        method: unfollowClinicEndPoint,
        data: {
          'ClinicId': ClinicId,
        },
      );
      print(response.data);
      emit(UnFollowSuccess());
    } on DioException catch (e) {
      print(e);
      emit(UnFollowError());
    }
  }

  List<DoctorModel> doctors = [];

  bool isNoSelect = false;
  void isNoSelectVoid(bool error) {
    isNoSelect = error;
    emit(isNoSelectStatue());
  }

  Future<void> getDoctor(ClinicCode) async {
    emit(GetDoctorLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method: getDoctorAppointmentsEndPoint(ClinicCode),
        language: false,
      );
      print(response.data);
      doctors = (response.data['data'] as List)
          .map((e) => DoctorModel.fromJson(e))
          .toList();

      emit(GetDoctorSuccess());
    } on DioException catch (e) {
      print(e);
      emit(GetDoctorError());
    }
  }

  bool clientINClinic = false;

  List<ClientClinicModel> petListInVet = [];

  Future getClientINClinic(ClinicCode) async {
    emit(GetDoctorLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method:
            getClientClinicEndPoint(ClinicCode, CacheHelper.getData('phone')),
        language: false,
      );
      print(response.data);
      clientINClinic = true;

      petListInVet = (response.data['data'] as List).map((e) {
        return ClientClinicModel.fromJson(e);
      }).toList();
      emit(GetDoctorSuccess());
    } on DioException catch (e) {
      print(e.response!.data);
      emit(GetDoctorError());
    }
  }

  bool isLoading = false;

  String convertLocalTimeToUTC(String time) {
    if (time.isEmpty) {
      return '';
    }

    // Split the time string into hours, minutes, and seconds
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);

    // Create a DateTime object with the provided time in local time zone
    DateTime localDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, minutes, seconds);

    // Convert local time to UTC
    DateTime utcDate = localDate.toUtc();

    // Format the UTC hours, minutes, and seconds to always have two digits
    String utcHours = utcDate.hour.toString().padLeft(2, '0');
    String utcMinutes = utcDate.minute.toString().padLeft(2, '0');
    String utcSeconds = utcDate.second.toString().padLeft(2, '0');

    return '$utcHours:$utcMinutes:$utcSeconds';
  }

  Future createAppointment({
    required String petId,
    String? doctorId,
    required String clinicCode,
    required String appointmentTime,
    required String appointmentDate,
    required int petGender,
    required String petName,
    required String clientId,
    required String petSqueakId,
    required bool isExisted,
    required bool notExistedOrPet,
    required bool isExistedNoPet,
    required bool isSpayed,
    // String? breedId,
    // String? specieId,
  }) async {
    isLoading = true;
    appointmentTime = convertLocalTimeToUTC(appointmentTime);
    emit(CreateAppointmentsLoading());
    try {
      if (isExisted) {
        print('isExisted');
        await _createAppointment(
          method: '$version/vetcare/reservation/existedClient',
          data: {
            "date": appointmentDate,
            "time": appointmentTime,
            "petId": petId,
            "clinicCode": clinicCode,
            'doctorUserId': doctorId,
            "clientId": petListInVet.first.clientId,
            "petSqueakId": petSqueakId,
          },
          successEmit: CreateExistedClientAppointment(),
        );
      } else if (isExistedNoPet) {
        await _createAppointment(
          method: '$version/vetcare/reservation/newPet',
          data: {
            "date": appointmentDate,
            "time": appointmentTime,
            "clinicCode": clinicCode,
            "clientId": clientId,
            'doctorUserId': doctorId,
            "pet": {
              "petName": petName,
              "petGender": petGender,
              "breedId": null,
              "specieId": null,
              "isSpayed": isSpayed,
            },
            "squeakPetId": petSqueakId
          },
          successEmit: CreateNewPetAppointment(),
        );
      } else if (notExistedOrPet) {
        await _createAppointment(
          method: '$version/vetcare/reservation/newPet/newClient',
          data: {
            "date": appointmentDate,
            "time": appointmentTime,
            "clinicCode": clinicCode,
            'doctorUserId': doctorId,
            "pet": {
              "petName": petName,
              "petGender": petGender,
              "squeakPetId": petSqueakId,
              "isSpayed": isSpayed,
              "breedId": null,
              "specieId": null,
            },
            "client": {
              "name": CacheHelper.getData('clientName'),
              "squeakClientId": CacheHelper.getData('clintId'),
              'countryId': CacheHelper.getData('countryId'),
              "phone": CacheHelper.getData('phone'),
              "gender": 1,
            },
          },
          successEmit: CreateNewPetAndClientAppointment(),
        );
      }

      isLoading = false;
      emit(CreateAppointmentsSuccess());
    } on DioException catch (e) {
      print(e.response!.data);
      isLoading = false;
      emit(CreateAppointmentsError(ErrorMessageModel.fromJson(e.response!.data)));
    }
  }

  Future<void> _createAppointment({
    required String method,
    required Map<String, dynamic> data,
    required successEmit,
  }) async {
    Response response = await DioFinalHelper.postData(
      method: method,
      data: data,
    );

    print(response.data);
    emit(successEmit);
  }
}
