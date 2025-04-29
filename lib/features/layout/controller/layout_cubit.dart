import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/features/appointments/models/print_model.dart';
import 'package:squeak/features/appointments/view/appointments/get_user_appointment.dart';
import 'package:squeak/features/appointments/view/supplier/get_supplier.dart';
import 'package:squeak/features/comments/data/model/comment_model.dart';
import 'package:squeak/features/pets/models/pet_model.dart';
import 'package:squeak/features/layout/models/version_model.dart';
import 'package:squeak/features/layout/post/presentation/screens/home_screen.dart';
import 'package:squeak/features/settings/view/setting_screen.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../models/owner_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    HomeScreen(),
    MySupplierScreen(
      petId: '',
      isSpayed: null,
      petNameFromAppoinmentIcon: null,
      genderForPetFromAppoinmentScreen: null,
    ),
    GetUserAppointment(), // Corrected: Removed non-ASCII character
    SettingScreen(), // Assuming this is intentional
  ];

  int selectedIndex = 0;

  void changeBottomNav(int index) {
    selectedIndex = index;
    emit(ChangeBottomNavState());
  }

  void breakLoadingAfterUpdated(context, pets) {
    emit(SqueakUpdateProfilelaodingUpdated());
    Navigator.pop(context);

    if (CacheHelper.getData('clintId') == pets.petId) {
      CacheHelper.saveData('isPet', false);
    } else {
      CacheHelper.saveData('isPet', true);
    }
    Future.delayed(const Duration(seconds: 1), () {
      CacheHelper.removeData('ImageActive');
      CacheHelper.removeData('name');
      CacheHelper.removeData('activeId');
      CacheHelper.saveData('ImageActive', pets.imageName);
      CacheHelper.saveData('gender', pets.gender);
      CacheHelper.saveData('activeId', pets.petId);
      CacheHelper.saveData('name', pets.petName);
      emit(SqueakUpdateProfileSuccessfulyUpdated());
    });
  }

  List<PetModel> pets = [];

  Future<void> getOwnerPet() async {
    emit(SqueakGetOwnerPetlaoding());
    try {
      Response response = await DioFinalHelper.getData(
        method: getOwnerPetEndPoint,
        language: false,
      );

      pets = (response.data['data']['petsDto'] as List)
          .map((e) => PetModel.fromJson(e))
          .toList();
      String jsonToString = json.encode(response.data['data']['petsDto']);

      CacheHelper.saveData('usersPets', jsonToString);
      emit(SqueakGetOwnerPetSuccess());
    } on DioException catch (e) {
      print(e.response!.data + '**********************');
      emit(SqueakGetOwnerPetError());
    }
  }

  OwnerModel profile = OwnerModel(
    userName: 'UserName',
    fullName: 'FullName',
    countryId: 1,
    email: 'Email',
    phone: 'Phone',
    address: 'Address',
    imageName: "$imageUrl" "420231014064959544.png",
    birthdate: 'BirthDate',
    gender: 1,
    role: 1,
    id: 'ID',
  );

  Future<void> getOwnerData() async {
    emit(SqueakGetOwnerDataLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method: getProfileEndPoint,
        language: false,
      );
      profile = OwnerModel.fromJson(response.data['data']['user']);
      CacheHelper.saveData('countryId', profile.countryId);
      emit(SqueakGetOwnerDataSuccess());
    } on Exception {
      emit(SqueakGetOwnerDataError());
    }
  }

  void addUserToProfile() {
    PetModel petsData = PetModel(
      petId: profile.id,
      specieId: '',
      petName: profile.fullName,
      breedId: profile.id,
      gender: profile.gender,
      imageName: profile.imageName,
      birthdate: profile.birthdate,
      isSpayed: true,
    );

    List<PetModel> updatedList = List.from(pets);

    bool petExists = false;

    for (var element in updatedList) {
      if (petsData.petId == element.petId) {
        petExists = true;
        break;
      }
    }

    if (!petExists) {
      updatedList.add(petsData);
      pets = updatedList;
    }

    emit(SqueakUpdateProfileSuccessfulyUpdated());
  }

  VerSionModel? version;
  bool getVersionFromBackLoading = true;
  void getVersion() async {
    getVersionFromBackLoading = true;
    emit(SqueakGetVersionLoading());
    try {
      var getVersionEndPointBasedOnOS =
          Platform.isAndroid ? getVersionEndPoint : getVersionEndPointIOS;

      debugPrint("📌 API Call Triggered");
      debugPrint("📱 Running on: ${Platform.isAndroid ? "Android" : "iOS"}");
      debugPrint("🔗 API Endpoint: $getVersionEndPointBasedOnOS");

      Response response = await DioFinalHelper.getData(
        method: getVersionEndPointBasedOnOS,
        language: false,
      );

      debugPrint("✅ API Response Status Code: ${response.statusCode}");
      debugPrint("📩 API Response Data: ${response.data}");

      print("=============");
      print("-=-=");
      print("res : ${response.data}");
      version = VerSionModel.fromJson(response.data);
      print(version?.toJson());
      getVersionFromBackLoading = false;
      emit(SqueakGetVersionSuccess());
    } on Exception catch (e) {
      getVersionFromBackLoading = false;
      print("!!!!");
      print(e.toString());
      emit(SqueakGetVersionError());
    }
  }

  late String currentVersion;
  Future<void> getAppVersion() async {
    emit(GetCurrentVersionLoading());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
    print("!!!");
    print("current Version $currentVersion");
    emit(GetCurrentVersionSuccess());
  }
}
