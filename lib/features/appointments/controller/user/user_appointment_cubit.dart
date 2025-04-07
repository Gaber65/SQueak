import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/helper/build_service/firebase_service.dart';
import 'package:squeak/core/helper/image_helper/helper_model/response_model.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/appointments/models/get_appointment_model.dart';
import 'package:squeak/features/appointments/view/appointments/print_reciept.dart';
import 'package:squeak/features/layout/models/clinic_model.dart';

import '../../../../core/constant/global_function/global_function.dart';
import '../../../../core/helper/cache/cache_helper.dart';
import '../../../../core/helper/remotely/dio.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

import '../../models/print_model.dart';

part 'user_appointment_state.dart';

class UserAppointmentCubit extends Cubit<UserAppointmentState> {
  UserAppointmentCubit() : super(UserAppointmentInitial()) {}

  static UserAppointmentCubit get(context) => BlocProvider.of(context);

  List<AppointmentModel> appointments = [];
  int appointmentsCount = 0;
  Future<void> getAppointment(bool applyFilter) async {
    if (CacheHelper.getData('appointments') != null) {
      String stringToJason = CacheHelper.getData('appointments')!;
      var jsonToMap = json.decode(stringToJason);
      appointmentsCount = jsonToMap.length;
      appointments = List<AppointmentModel>.from(
          jsonToMap.map((x) => AppointmentModel.fromJson(x))).where((element) {
        DateTime appointmentDate = DateTime.parse(element.date);
        return appointmentDate
            .isAfter(DateTime.now().subtract(const Duration(days: 1)));
      }).toList();

      appointments.sort((a, b) => a.date.compareTo(b.date));
      emit(GetAppointmentSuccess());
    }
    emit(GetAppointmentLoading());

    try {
      Response response = await DioFinalHelper.getData(
        method: createAndGetAppointmentsEndPoint(CacheHelper.getData('phone')),
        language: true,
      );
      // print(response.data['data'][0]['id'].toString());
      // print("////////////////////////");
      // print(response.data['data']);
      // print("////////////////////////");
      //
      // print(response.data['data']['result'][0]['wieght']);
      // print("////////////////////////");
      //
      // response.data['data']['result'].forEach((e){
      //   print('wieght');
      //   print(e['wieght']);
      //   print('temprature');
      //   print(e['temprature']);
      // });
      // print("////////////////////////");
      //

      String jasonToString = json.encode(response.data['data']['result']);
      appointmentsCount = response.data['data']['result'].length;
      CacheHelper.saveData('appointments', jasonToString);
      appointments = (response.data['data']['result'] as List)
          .map((e) => AppointmentModel.fromJson(e))
          .toList();
      appointments.sort((a, b) => a.date.compareTo(b.date));
      if (applyFilter) {
        appointments.removeWhere((element) {
          DateTime appointmentDate = DateTime.parse(element.date);
          return appointmentDate
              .isBefore(DateTime.now().subtract(const Duration(days: 1)));
        });
      }

      emit(GetAppointmentSuccess());
    } on DioError catch (e) {
      print(e);
      emit(GetAppointmentError());
    }
  }

  void deleteAppointments(AppointmentModel model) async {
    emit(DeleteAppointmentLoading());
    try {
      await DioFinalHelper.postData(
        method: deleteAppointmentsEndPoint,
        data: {
          "reservationId": model.id,
        },
      );

      emit(DeleteAppointmentSuccess());
    } on DioError catch (e) {
      print(e);
      emit(DeleteAppointmentError());
      throw e;
    }
  }

  void printReceipt(AppointmentModel model, context) async {
    navigateToScreen(
      context,
      PrintScreen(
        id: model.id,
        clinicPhone: model.clinicPhone,
        clinicImage: model.clinicLogo ?? '',
      ),
    );
  }

  Future<void> printPdf(Response response) async {
    try {
      await Printing.layoutPdf(
        onLayout: (format) {
          return Uint8List.fromList(response.data);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  int ratingCleanliness = 0;
  int ratingDoctor = 0;
  TextEditingController rateController = TextEditingController();
  bool isLoadingRate = false;

  Future rateAppointment(AppointmentModel model) async {
    isLoadingRate = true;
    emit(RateAppointmentLoading());
    try {
      await DioFinalHelper.postData(
        method: rateAppointmentEndPoint,
        data: {
          "reservationId": model.id,
          "cleanlinessRate": ratingCleanliness,
          "doctorServiceRate": ratingDoctor,
          "feedbackComment": rateController.text,
        },
      );
      isLoadingRate = false;
      CacheHelper.saveData('IsForceRate', false);
      CacheHelper.removeData('RateModel');
      emit(RateAppointmentSuccessFunction());
    } on DioError catch (e) {
      isLoadingRate = false;
      emit(RateAppointmentError());
      throw e;
    }
  }

  init(AppointmentModel model) {
    ratingCleanliness = model.cleanlinessRate;
    ratingDoctor = model.doctorServiceRate;
    rateController.text = model.feedbackComment ?? '';

    emit(RateAppointmentError());
  }

  MySupplierModel? suppliers;

  Future<void> getSupplier() async {
    emit(GetSupplierLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method: getFollowerClinicEndPoint,
        language: false,
      );
      suppliers = MySupplierModel.fromJson(response.data['data']);
      emit(GetSupplierSuccess());
    } on DioError catch (e) {
      print(e);
      emit(GetSupplierError());
    }
  }

  ClinicInfo? findClinic(
      List<ClinicInfo> data, String clinicCode, String clinicId) {
    for (var element in data) {
      if (element.data.code == clinicCode) {
        print('clinic found');
        return element;
      } else {
        print('clinic not found');
        followClinic(clinicId);
      }
    }
    return null;
  }

  Future followClinic(clinicId) async {
    emit(FollowLoading());
    try {
      await DioFinalHelper.postData(
        method: followClinicEndPoint,
        data: {
          "clinicId": clinicId,
        },
      );
      emit(FollowSuccess());
    } on DioError catch (e) {
      print(e.response!.data);
      emit(FollowError(ResponseModel.fromJson(e.response!.data)));
    }
  }

  InvoicesModel? invoices;
  PetModel? pet;
  OwnerModel? owner;
  bool isLoadingInvoice = false;
  Future getInvoives(id) async {
    emit(GetInvoicesLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method: invoiveEndPoint + id,
        language: false,
      );
      invoices = InvoicesModel.fromJson(response.data['data']);
      print("${invoices!.species} =====================");
      var petMap = {
        'petName': invoices!.petName,
        'species': invoices!.species,
        'sex': invoices!.sex,
      };
      pet = PetModel.fromJson(petMap);

      var ownerMap = {
        'ownerName': invoices!.ownerName,
        'phone': invoices!.clientPhone,
      };
      owner = OwnerModel.fromJson(ownerMap);
      emit(GetInvoicesSuccess());
    } on DioError catch (e) {
      print(e);
      emit(GetInvoicesError(ResponseModel.fromJson(e.response!.data)));
    }
  }

  List<AppointmentModel> filteredList = []; // Store filtered appointments

  String? selectedPetId;
  String? petName;
  int? selectedState;

  String? selectedStateValue;

  void filterAppointments() {
    filteredList = appointments.where((appointment) {
      final matchesPet =
          selectedPetId == null || appointment.pet.squeakPetId == selectedPetId;
      final matchesState =
          selectedState == null || appointment.statues == selectedState;
      return matchesPet && matchesState;
    }).toList();
    emit(AppointmentFiltered(filteredList));
  }

  void clearFilters() {
    selectedPetId = null;
    selectedState = null;
    selectedStateValue = null;
    petName = null;
    filteredList = List.from(appointments); // Reset to original list
    emit(AppointmentFilteredClear(filteredList));
  }

  @override
  Future<void> close() {
    print('close Cubit');
    CacheHelper.removeData('NotificationId');
    CacheHelper.removeData('NotificationType');

    return super.close();
  }
}
