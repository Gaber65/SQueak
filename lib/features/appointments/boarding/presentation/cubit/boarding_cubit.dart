import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/boarding_entry.dart';
import '../../domain/entities/boarding_type.dart';

part 'boarding_state.dart';

class BoardingCubit extends Cubit<BoardingState> {
  BoardingCubit() : super(BoardingInitial());
  static BoardingCubit get(context) => BlocProvider.of<BoardingCubit>(context);
  List<ClinicBoardEntity> dummyClinicBoardEntities = [];

  Future<void> getBoardingType(ClinicCode) async {
    emit(GetBoardingTypeState());
    try {
      Response response = await DioFinalHelper.getData(
        method: boardingTypeEndPoint(ClinicCode),
        language: false,
      );
      dummyClinicBoardEntities =
          (response.data['data'] as List)
              .map((e) => ClinicBoardEntity.fromJson(e))
              .toList();
      dummyClinicBoardEntities =
          dummyClinicBoardEntities
              .where((element) => element.isActive == true)
              .toList();
      emit(GetBoardingTypeSuccess());
    } on DioException catch (e) {
      print(e);
      emit(GetBoardingTypeError());
    }
  }

  bool isLoading = false;
  Future createBoarding({
    required ClinicCode,
    required entryDate,
    required existDate,
    required period,
    required comment,
    required boardingTypeId,
    required vetICarePetId,
    required context,
  }) async {
    isLoading = true;
    emit(CreateBoardingState());
    try {
      await DioFinalHelper.postData(
        method: createBoardingEndPoint,
        data: {
          "entryDate": entryDate,
          "existDate": existDate,
          "clinicCode": ClinicCode,
          "period": period,
          "comment": comment,
          "boardingTypeId": boardingTypeId,
          "vetICarePetId": vetICarePetId,
        },
      );
      isLoading = false;
      emit(CreateBoardingSuccess());
    } on DioException catch (e) {
      print(e);
      isLoading = false;

      var model = ErrorMessageModel.fromJson(e.response!.data);
      errorToast(
        context,
        model.errors.isNotEmpty
            ? model.errors.values.first.first
            : model.message,
      );
      emit(CreateBoardingError(ErrorMessageModel.fromJson(e.response!.data)));
    }
  }

  bool isLoadingEdit = false;
  Future editBoarding({
    required ClinicCode,
    required entryDate,
    required existDate,
    required period,
    required comment,
    required boardingTypeId,
    required vetICarePetId,
    required id,
    required context,
    required int boardingStatus,
  }) async {
    isLoading = true;
    emit(CreateBoardingState());
    try {
      await DioFinalHelper.putData(
        method: editBoardingEndPoint,
        data: {
          "entryDate": entryDate,
          "id": id,
          "existDate": existDate,
          "clinicCode": ClinicCode,
          "period": period,
          "comment": comment,
          "boardingTypeId": boardingTypeId,
          "vetICarePetId": vetICarePetId,
          "status": boardingStatus,
        },
      );
      isLoading = false;
      emit(CreateBoardingSuccess());
    } on DioException catch (e) {
      print(e);
      isLoading = false;

      var model = ErrorMessageModel.fromJson(e.response!.data);
      errorToast(
        context,
        model.errors.isNotEmpty
            ? model.errors.values.first.first
            : model.message,
      );
      emit(CreateBoardingError(ErrorMessageModel.fromJson(e.response!.data)));
    }
  }

  List<BoardingEntry> boardingEntry = [];
  Future<void> getBoardingEntry() async {
    if (CacheHelper.getData('boardingEntry') != null) {
      String stringToJason = CacheHelper.getData('boardingEntry')!;
      var jsonToMap = json.decode(stringToJason);
      boardingEntry =
          List<BoardingEntry>.from(
            jsonToMap.map((x) => BoardingEntry.fromJson(x)),
          ).toList();
    }
    emit(GetBoardingEntryState());
    try {
      Response response = await DioFinalHelper.getData(
        method: getAllBoardingEndPoint(CacheHelper.getData('phone')),
        language: false,
      );
      boardingEntry =
          (response.data['data']['result'] as List)
              .map((e) => BoardingEntry.fromJson(e))
              .toList();
      boardingEntry.removeWhere((element) {
        DateTime BoardingDate = DateTime.parse(element.existDate);
        return BoardingDate.isBefore(
          DateTime.now().subtract(const Duration(days: 1)),
        );
      });
      String jasonToString = json.encode(response.data['data']['result']);
      CacheHelper.saveData('boardingEntry', jasonToString);
      emit(GetBoardingEntrySuccess());
    } on DioException catch (e) {
      print(e);
      emit(GetBoardingEntryError());
    }
  }

  int ratingCleanliness = 0;
  int ratingDoctor = 0;
  TextEditingController rateController = TextEditingController();
  bool isLoadingRate = false;

  Future rateBoarding(BoardingEntry model) async {
    isLoadingRate = true;
    emit(RateBoardingLoading());
    try {
      await DioFinalHelper.postData(
        method: rateBoardingEndPoint,
        data: {
          "boardingId": model.id,
          "cleanlinessRate": ratingCleanliness,
          "doctorServiceRate": ratingDoctor,
          "feedbackComment": rateController.text,
        },
      );
      isLoadingRate = false;
      CacheHelper.saveData('IsForceRate', false);
      CacheHelper.removeData('RateModel');
      emit(RateBoardingSuccess());
    } on DioError catch (e) {
      isLoadingRate = false;
      emit(RateBoardingError());
      throw e;
    }
  }

  init(BoardingEntry model) {
    ratingCleanliness = model.cleanlinessRate;
    ratingDoctor = model.doctorServiceRate;
    rateController.text = model.feedbackComment ?? '';

    emit(RateBoardingError());
  }

  List<BoardingEntry> filteredList = []; // Store filtered Boardings

  String? selectedPetId;
  String? petName;
  int? selectedState;

  String? selectedStateValue;

  void filterBoardings() {
    filteredList =
        boardingEntry.where((Boarding) {
          final matchesPet =
              selectedPetId == null || Boarding.pet.name == selectedPetId;
          final matchesState =
              selectedState == null || Boarding.status == selectedState;
          return matchesPet && matchesState;
        }).toList();
    emit(BoardingFiltered(filteredList));
  }

  void clearFilters() {
    selectedPetId = null;
    selectedState = null;
    selectedStateValue = null;
    petName = null;
    filteredList = List.from(boardingEntry); // Reset to original list
    emit(BoardingFilteredClear(filteredList));
  }
}
