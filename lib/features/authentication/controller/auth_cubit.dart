import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phone_text_field/model/phone_number.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../layout/controller/layout_cubit.dart';
import '../../vetcare/models/vetIcare_client_model.dart';
import '../models/country_model.dart';
import '../models/login.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final countryId = TextEditingController();
  final commentController = TextEditingController();
  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final followCodeController = TextEditingController();
  bool isAccept = true;

  void allToShareDataWithVetICare() {
    isAccept = !isAccept;
    emit(LoadingRegisterState());
  }

  bool isLoggedIn = false;

  void init(context) {
    if (CacheHelper.getData('phone') != null) {
      var c = LayoutCubit.get(context);
      emailController.text = c.profile.email;
      nameController.text = c.profile.fullName;
      phoneController.text = c.profile.phone;
    }
  }

  PhoneNumber? phoneNumber;

  void clearLogin() {
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    nameController.clear();
  }

  void clearRegister() {
    passwordController.clear();
    phoneController.clear();
    nameController.clear();
  }

  Future<void> login(context) async {
    isLoggedIn = true;

    var emailOrPhoneNumber = emailController.text;
    if (!isEmail(emailController.text)) {
      print(emailOrPhoneNumber);
      emailOrPhoneNumber = normalizePhoneNumber(emailOrPhoneNumber);
      print(emailOrPhoneNumber);
    }

    emit(LoadingLoginState());
    try {
      Response response = await DioFinalHelper.postData(
        method: loginEndPoint,
        data: {
          'emailOrPhoneNumber': emailOrPhoneNumber,
          'password': passwordController.text,
          'FbToken': CacheHelper.getData('DeviceToken') ??
              await FirebaseMessaging.instance.getToken(),
        },
      );

      isLoggedIn = false;
      clearLogin();
      var model = AuthModel.fromJson(response.data);

      CacheHelper.saveData('token', model.data!.token);
      MainCubit.get(context).saveToken();

      emit(SuccessLoginState(model));
    } on DioException catch (e) {
      isLoggedIn = false;
      emit(ErrorLoginState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  bool isRegister = false;

  Future<void> register() async {
    isRegister = true;

    var phone = phoneController.text;
    // phone = normalizePhoneNumber(phone);
    print(phone);

    emit(LoadingRegisterState());

    try {
      await DioFinalHelper.postData(
        method: registerEndPoint,
        data: {
          "fullName": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "Gender": 1,
          "PasswordConfirm": passwordController.text,
          "userName": emailController.text,
          "userType": 1,
          "countryId": countryIdToServer,
          "phone": phone,
        },
      );

      isRegister = false;
      clearRegister();
      CacheHelper.saveData(
        "followCode",
        followCodeController.text.trim(),
      );
      emit(SuccessRegisterState());
    } on DioException catch (e) {
      isRegister = false;
      print(e.response?.data);
      emit(ErrorRegisterState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  Future<void> registerQr(clinicCode, context) async {
    isLoggedIn = true;

    var phone = phoneController.text;
    phone = normalizePhoneNumber(phone);
    print(phone);

    emit(LoadingRegisterState());

    try {
      await DioFinalHelper.putData(
        method: registerQrEndPoint,
        data: {
          "fullName": nameController.text,
          "phoneNumber": phone,
          "email": emailController.text,
          "password": passwordController.text,
          "countryId": CacheHelper.getData('countryId') == '+20'
              ? 1
              : CacheHelper.getData('countryId'),
          "clinicCode": clinicCode,
          "allToShareDataWithVetICare": isAccept,
          "gender": 1
        },
      );
      login(context);
      emit(SuccessRegisterState());
    } on DioException catch (e) {
      isLoggedIn = false;
      print(e.response?.data);
      emit(ErrorRegisterState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  bool isForgetPassword = false;

  Future<void> forgetPassword() async {
    isForgetPassword = true;
    emit(ForgetPasswordLoadingState());
    try {
      await DioFinalHelper.postData(
        method: forgetPasswordEndPoint,
        data: {
          "email": emailController.text,
        },
      );
      isForgetPassword = false;
      emit(ForgetPasswordSuccessState());
    } on DioException catch (e) {
      isForgetPassword = false;
      emit(ForgetPasswordErrorState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  bool isRestPassword = false;

  Future<void> restPassword(emailController) async {
    isRestPassword = true;
    emit(RestPasswordLoadingState());
    try {
      Response e = await DioFinalHelper.postData(
        method: resetPasswordEndPoint,
        data: {
          "email": emailController,
          "tokenCode": codeController.text,
          "newPassword": passwordController.text,
          "confirmNewPassword": passwordController.text,
        },
      );
      isRestPassword = false;
      emit(RestPasswordSuccessState(ErrorMessageModel.fromJson(e.data)));
    } on DioException catch (e) {
      isRestPassword = false;
      print(e.response?.data);
      emit(RestPasswordErrorState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  bool isVerifyUser = false;

  Future<void> verifyUser(tokenCode, email) async {
    isVerifyUser = true;
    emit(VerifyUserLoadingState());
    try {
      await DioFinalHelper.postData(
        method: verificationCodeEndPoint,
        data: {
          "email": email,
          "tokenCode": tokenCode,
          "clinicCode": followCodeController.text.trim(),
        },
      );
      isVerifyUser = false;
      emit(VerifyUserSuccessState());
    } on DioException catch (e) {
      isVerifyUser = false;
      print(e.response?.data);
      print("Elkerm status code ${e.response?.statusCode}");
      emit(VerifyUserErrorState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  bool isContactUs = false;

  Future<void> contactUs() async {
    isContactUs = true;
    emit(ContactUsLoadingState());
    try {
      await DioFinalHelper.postData(
        method: contactUsEndPoint,
        data: {
          "title": titleController.text,
          "phone": phoneController.text,
          "fullName": nameController.text,
          "comment": commentController.text,
          "email": emailController.text,
          "statues": false,
        },
      );
      isContactUs = false;
      emit(ContactUsSuccessState());
    } on DioException catch (e) {
      isContactUs = false;
      print(e.response?.data);
      emit(ContactUsErrorState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  List<VetClientModel> vetClientModel = [];

  Future<List<VetClientModel>> getClintFormVetVoid(
      String code, bool isFilter) async {
    isLoggedIn = true;
    try {
      Response response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(code, CacheHelper.getData('phone')),
        language: true,
      );

      print('Received response: ${response.data["data"]}');

      if (isFilter) {
        vetClientModel = List<VetClientModel>.from(
                response.data["data"].map((x) => VetClientModel.fromJson(x)))
            .where((element) => element.addedInSqueakStatues == false)
            .toList();
      } else {
        vetClientModel = List<VetClientModel>.from(
            response.data["data"].map((x) => VetClientModel.fromJson(x)));
      }

      isLoggedIn = true;
      return vetClientModel;
    } on DioException {
      isLoggedIn = false;
      emit(FollowSuccess(false));

      return []; // Return an empty list in case of an error
    }
  }

  void clearContactUs() {
    titleController.clear();
    phoneController.clear();
    nameController.clear();
    commentController.clear();
    emailController.clear();
  }

  String? password;
  String? Username;
  List<CountryModel> countries = [];

  Future getCountry(String name) async {
    getTokenFormFirebase();
    try {
      String username = Username ?? 'Ahmed.Omar@Veticare.com';
      String passwordBasic = password ?? 'Password@123';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$passwordBasic'));
      var dio = Dio();
      Response response = await dio.request(
        '${ConfigModel.baseApiUrlSqueak}$version/squeak/countries?Name=$name',
        options: Options(
          method: 'GET',
          headers: {
            'accept': '*/*',
            'Authorization': basicAuth,
          },
        ),
      );

      dio.interceptors.add(ChuckerDioInterceptor());

      print("@@@@@@@@@@@@@@@@@");
      print(response.data['data'][0]);

      countries = (response.data['data'] as List)
          .map((e) => CountryModel.fromJson(e))
          .toList();
      countries.removeWhere(
        (element) => element.id == 2,
      );
      emit(GetCountrySuccessState());
    } on DioException catch (e) {
      print(e.response);
    }
  }

  Future getTokenFormFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserToken')
          .doc('Is0fJjcbMCqOrWmQdKoj')
          .snapshots()
          .listen((event) {
        print(event.data());
        Username = event.data()!['Username'];
        password = event.data()!['password'];
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  String countryCode = "EG";
  String countryPhoneCode = "+20";
  int countryIdToServer = 1;

  setCountryCodeAuto({required newCountryCode}) {
    countryCode = newCountryCode;
    emit(GetCurrentCountryCodeSuccessState());
  }

  Future<String?> getCountryCode() async {
    emit(GetCurrentCountryCodeLoadingState());
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(GetCurrentCountryCodeErrorState());
          return "Permission Denied";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(GetCurrentCountryCodeErrorState());
        return "Permission Denied Forever";
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get the country name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        // 29.2156484,
        // 11.2156484,
      );

      if (placemarks.isNotEmpty) {
        String countryName = placemarks.first.country ?? "Unknown";
        CacheHelper.saveData('countryNameE', countryName);
        print("####################");
        print(countryName);

        countries.forEach((e) {
          if (e.name == countryName) {
            countryPhoneCode = e.phoneCode;
            countryIdToServer = e.id;
            print("YESSSS");
          }
        });
        setCountryCodeAuto(newCountryCode: countryName);
        emit(GetCurrentCountryCodeSuccessState());
        return countryName; // Example: "Egypt", "United States", "India"
      }
    } catch (e) {
      emit(GetCurrentCountryCodeErrorState());
      print("Error getting country name: $e");
    }
    return null;
  }

  initTheVerifyUser({required newOtp}) {
    followCodeController.text = CacheHelper.getData("followCode") ?? "";
  }
}
