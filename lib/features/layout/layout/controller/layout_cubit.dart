import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/features/appointments/view/appointments/get_user_appointment.dart';
import 'package:squeak/features/appointments/view/supplier/get_supplier.dart';
import 'package:squeak/features/layout/post/presentation/screens/home_screen.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../settings/persentaion/view/setting_screen.dart';
import '../models/version_model.dart';


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
