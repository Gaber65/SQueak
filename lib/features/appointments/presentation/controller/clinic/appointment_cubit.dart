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
      print("DEBUG: Fetching client pets for clinic code: $ClinicCode with phone: ${CacheHelper.getData('phone')}");
      Response response = await DioFinalHelper.getData(
        method:
            getClientClinicEndPoint(ClinicCode, CacheHelper.getData('phone')),
        language: false,
      );
      print("DEBUG: Client API response: ${response.data}");
      clientINClinic = true;

      petListInVet = (response.data['data'] as List).map((e) {
        print("DEBUG: Processing pet from API: ${e}");
        return ClientClinicModel.fromJson(e);
      }).toList();
      
      print("DEBUG: Retrieved ${petListInVet.length} pets for client in clinic");
      for (var pet in petListInVet) {
        print("DEBUG: Pet - ID: ${pet.petId}, Name: ${pet.petName}, SqueakID: ${pet.petSqueakId}");
      }
      
      emit(GetDoctorSuccess());
    } on DioException catch (e) {
      print("DEBUG: Error fetching client in clinic: ${e.response?.data}");
      emit(GetDoctorError());
    }
  }

  bool isLoading = false;

  String convertLocalTimeToUTC(String time) {
    if (time.isEmpty) {
      return '';
    }

    print("DEBUG: Converting time to UTC: $time");
    
    try {
      // Handle AM/PM format if present
      bool isPM = false;
      if (time.toUpperCase().contains('PM')) {
        isPM = true;
        time = time.replaceAll(RegExp(r'[pP][mM]'), '').trim();
      } else if (time.toUpperCase().contains('AM')) {
        time = time.replaceAll(RegExp(r'[aA][mM]'), '').trim();
      }
      
      // Split the time string into hours, minutes, and seconds
      final parts = time.split(':');
      
      if (parts.length < 2) {
        print("DEBUG: Invalid time format: $time");
        return time; // Return as is if invalid format
      }
      
      // Parse the time components
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;
      
      // Adjust for PM time
      if (isPM && hours < 12) {
        hours += 12;
      }
      // Adjust for 12 AM
      if (!isPM && hours == 12) {
        hours = 0;
      }
      
      print("DEBUG: Parsed time - Hours: $hours, Minutes: $minutes, Seconds: $seconds");
      
      // Create a DateTime object with the provided time in local time zone
      DateTime localDate = DateTime(
        DateTime.now().year, 
        DateTime.now().month,
        DateTime.now().day, 
        hours, 
        minutes, 
        seconds
      );
      
      // Convert local time to UTC
      DateTime utcDate = localDate.toUtc();
      
      // Format the UTC hours, minutes, and seconds to always have two digits
      String utcHours = utcDate.hour.toString().padLeft(2, '0');
      String utcMinutes = utcDate.minute.toString().padLeft(2, '0');
      String utcSeconds = utcDate.second.toString().padLeft(2, '0');
      
      String result = '$utcHours:$utcMinutes:$utcSeconds';
      print("DEBUG: Converted UTC time: $result");
      return result;
    } catch (e) {
      print("DEBUG: Error converting time to UTC: $e");
      return time; // Return original if there's an error
    }
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
    try {
      // Simplified time handling - ensure format is HH:MM:SS
      print("DEBUG: Original appointment time: $appointmentTime");
      
      // Directly format the time without complex conversion
      // Just ensure it has seconds
      if (!appointmentTime.contains(':')) {
        appointmentTime = "$appointmentTime:00:00"; // Handle case where only hour is provided
      } else if (appointmentTime.split(':').length == 2) {
        appointmentTime = "$appointmentTime:00"; // Add seconds if only HH:MM format
      }
      
      print("DEBUG: Formatted time: $appointmentTime");
      
      emit(CreateAppointmentsLoading());
      
      print("DEBUG: Creating appointment with params:");
      print("DEBUG: petId: $petId");
      print("DEBUG: doctorId: $doctorId");
      print("DEBUG: clinicCode: $clinicCode");
      print("DEBUG: appointmentTime: $appointmentTime");
      print("DEBUG: appointmentDate: $appointmentDate");
      print("DEBUG: clientId: $clientId");
      print("DEBUG: petSqueakId: $petSqueakId");
      
      if (isExisted) {
        print('DEBUG: Using existedClient endpoint');
        
        // Make sure petListInVet is not empty before proceeding
        if (petListInVet.isEmpty) {
          print("DEBUG: petListInVet is empty, cannot proceed");
          throw DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'No pets found in this clinic',
            response: Response(
              requestOptions: RequestOptions(path: ''),
              data: {
                'message': 'No pets found in this clinic',
                'errors': {}
              },
              statusCode: 400,
            ),
          );
        }
        
        // Create the request payload - SIMPLIFIED and DIRECT approach
        Map<String, dynamic> requestData = {
          "date": appointmentDate,
          "time": appointmentTime,
          "petId": petId,
          "clinicCode": clinicCode,
          "clientId": clientId,
          "petSqueakId": petSqueakId,
          "squeakClientId": CacheHelper.getData('clintId'),
        };
        
        // Only add doctorId if it's not null and not empty
        if (doctorId != null && doctorId.isNotEmpty) {
          requestData["doctorUserId"] = doctorId;
        }
        
        // Add notes/comments if not empty
        if (commentController.text.isNotEmpty) {
          requestData["notes"] = commentController.text;
        }
        
        print("DEBUG: Request payload for existedClient: $requestData");
        
        // Make the API call
        try {
          print("DEBUG: Sending direct API request");
          Response response;
          try {
            // First attempt with IDs as provided
            response = await DioFinalHelper.postData(
              method: '$version/vetcare/reservation/existedClient',
              data: requestData,
            );
            print("DEBUG: API response: ${response.data}");
          } catch (e) {
            print("DEBUG: First attempt failed, trying with swapped IDs: $e");
            
            // Create a new request with swapped IDs
            Map<String, dynamic> swappedData = Map.from(requestData);
            String tempId = swappedData['petId'];
            swappedData['petId'] = swappedData['petSqueakId'];
            swappedData['petSqueakId'] = tempId;
            
            print("DEBUG: Trying with swapped IDs: $swappedData");
            response = await DioFinalHelper.postData(
              method: '$version/vetcare/reservation/existedClient',
              data: swappedData,
            );
            print("DEBUG: Swapped IDs API response: ${response.data}");
          }
          
          emit(CreateExistedClientAppointment());
          isLoading = false;
          emit(CreateAppointmentsSuccess());
          return;
        } catch (e) {
          print("DEBUG: Direct API error: $e");
          rethrow; // Let the outer catch block handle this
        }
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
    try {
      print("DEBUG: Sending request to: $method");
      print("DEBUG: Request data: $data");
      
      Response response = await DioFinalHelper.postData(
        method: method,
        data: data,
      );

      print("DEBUG: Response data: ${response.data}");
      emit(successEmit);
    } catch (error) {
      print("DEBUG: Error in _createAppointment: $error");
      if (error is DioException) {
        print("DEBUG: DioException details:");
        print("DEBUG: - Status code: ${error.response?.statusCode}");
        print("DEBUG: - Response data: ${error.response?.data}");
        print("DEBUG: - Error message: ${error.message}");
        if (error.response?.data is Map) {
          Map<String, dynamic> errorData = error.response?.data;
          print("DEBUG: - Error details: ${errorData['errors']}");
          print("DEBUG: - Error message: ${errorData['message']}");
          
          // Check if the error is related to the pet ID or owner
          if (method == '$version/vetcare/reservation/existedClient' && 
              errorData['errors'] != null && 
              errorData['errors']['Squeak Pet Id'] != null &&
              (errorData['errors']['Squeak Pet Id'].contains('Looks like this pet isn\'t around anymore.') || 
               errorData['errors']['Squeak Pet Id'].contains('Owner Required'))) {
              
            // Try swapping the IDs as a fallback
            if (data.containsKey('petId') && data.containsKey('petSqueakId')) {
              String tempId = data['petId'];
              print("DEBUG: Trying with swapped IDs as fallback");
              
              // Create a copy of the data with swapped IDs
              Map<String, dynamic> swappedData = Map.from(data);
              swappedData['petId'] = data['petSqueakId'];
              swappedData['petSqueakId'] = tempId;
              
              print("DEBUG: Fallback request with swapped IDs: $swappedData");
              
              try {
                Response swappedResponse = await DioFinalHelper.postData(
                  method: method,
                  data: swappedData,
                );
                print("DEBUG: Fallback succeeded! Response: ${swappedResponse.data}");
                emit(successEmit);
                return; // Return if successful to avoid rethrowing
              } catch (swappedError) {
                print("DEBUG: Fallback also failed: $swappedError");
                // Fall through to rethrow the original error
              }
            }
          }
        }
      }
      rethrow;
    }
  }
}
