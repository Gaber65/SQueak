import 'dart:convert';
import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/helper/remotely/dio.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squeak/features/authentication/models/login.dart';
import 'package:squeak/features/vetcare/models/vetIcare_client_model.dart';
import '../../../core/constant/global_function/global_function.dart';
import '../../../core/helper/image_helper/helper_model/response_model.dart';
import '../../../core/helper/remotely/config_model.dart';
import '../../layout/models/Notification_model.dart';
import '../../layout/models/clinic_model.dart';

part 'vet_state.dart';

class VetCubit extends Cubit<VetState> {
  VetCubit() : super(VetInitial());

  static VetCubit get(context) => BlocProvider.of(context);

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final imageController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final birthDateController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isRegister = false;

  Future<void> register() async {
    isRegister = true;
    var phone = phoneController.text;
    phone = normalizePhoneNumber(phone);
    print(phone);

    emit(LoadingRegisterState());

    try {
      final response = await DioFinalHelper.postData(
        method: vetIcareReigster,
        data: {
          "fullName": vetClientModelOne!.name,
          "email": emailController.text,
          "fbToken": CacheHelper.getData('DeviceToken') ?? 'sdsdsd',
          "userName": emailController.text,
          "password": passwordController.text,
          "passwordConfirm": passwordController.text,
          "userType": 1,
          "phone": phoneController.text,
          "clientId":
              vetClientModelOne == null ? '' : vetClientModelOne!.vetICareId,
          "birthDate": birthDateController.text,
          "gender": 1,
          "clinicCode": vetClientModelOne!.clinicCode,
          "CountryId": vetClientModelOne!.countryId,
        },
      );
      List<VetClientModel> vetClientModel = List<VetClientModel>.from(
              response.data["data"].map((x) => VetClientModel.fromJson(x)))
          .toList();

      CacheHelper.removeData('invitationCode');
      if (vetClientModel.first.id.contains('0000')) {
        login(false);
      } else {
        login(true);
      }
      emit(SuccessRegisterState());
    } on DioException catch (e) {
      isRegister = false;
      emit(ErrorRegisterState(ResponseModel.fromJson(e.response?.data)));
    }
  }

  List<NotificationModel> notifications = [];

  Future getNotifications(id) async {
    emit(NotificationsLoadingState());
    try {
      Response response = await DioFinalHelper.getData(
        method: '$version/notifications',
        language: true,
      );

      notifications = (response.data['data']['notificationDtos'] != null)
          ? (response.data['data']['notificationDtos'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList()
          : [];
      CacheHelper.saveData('notificationsNum', notifications.length);
      notifications.forEach((element) async {
        if (element.notificationEvents.isNotEmpty &&
            element.notificationEvents[0].id == id) {
          NotificationModel model = element;
          await updateState(model.notificationEvents[0].id);
        }
      });
      emit(NotificationsSuccessState());
    } on DioException catch (e) {
      print(e.response!.data);
      emit(NotificationsErrorState());
    }
  }

  Future updateState(id) async {
    print('UpdateState');
    emit(NotificationsLoadingState());
    try {
      final r = await DioFinalHelper.putData(
        method: '$version/notifications/$id',
        data: {},
      );
      print(r);
      emit(NotificationsSuccessState());
    } on DioException catch (e) {
      print(e.response!.data);
      emit(NotificationsErrorState());
    }
  }

  Future<void> login(isHavePet) async {
    emit(LoadingLoginState());
    try {
      Response response = await DioFinalHelper.postData(
        method: loginEndPoint,
        data: {
          'emailOrPhoneNumber': vetClientModelOne!.phone,
          'Password': passwordController.text,
        },
      );
      isRegister = false;
      emit(SuccessLoginState(AuthModel.fromJson(response.data), isHavePet));
    } on DioException catch (e) {
      isRegister = false;
      print(e.response);
      emit(ErrorLoginState(ResponseModel.fromJson(e.response?.data)));
    }
  }

  String? password;
  String? Username;
  DataVet? vetClientModelOne;
  Future getClient(String invitationCode) async {
    getTokenFormFirebase();
    emit(LoadingGetClientState());

    try {
      String username = Username ?? 'Ahmed.Omar@Veticare.com';
      String passwordBasic = password ?? 'Password@123';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$passwordBasic'));
      var dio = Dio();
      Response response = await dio.request(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/$invitationCode',
        options: Options(
          method: 'GET',
          headers: {
            'accept': '*/*',
            'Authorization': basicAuth,
          },
        ),
      );
      dio.interceptors.add(ChuckerDioInterceptor());
      vetClientModelOne = DataVet.fromJson(response.data['data']);
      print(vetClientModelOne!.toJson());
      phoneController.text = vetClientModelOne!.phone;
      emailController.text = vetClientModelOne!.email;
      print(emailController.text + '***********************');
      emit(SuccessGetClientState());
    } on DioException catch (e) {
      print(e.response);
      emit(ErrorGetClientState());
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

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getPitsImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  Clinic? entities;
  Future getClinicbyID(id) async {
    emit(LoadingGetClinicState());

    try {
      Response response = await DioFinalHelper.getData(
        method: addClinicEndPoint + '/' + id,
        language: true,
      );

      entities = Clinic.fromJson(response.data['data']['clinic']);

      await getClientInapp(
        entities!.code,
      );
      emit(SuccessGetClinicState());
    } on DioException catch (e) {
      print(e);
      emit(ErrorGetClinicState());
    }
  }

  bool isGetVet = false;
  List<VetClientModel> vetClientModel = [];
  Future getClintFormVetVoid(String Code, isFilter) async {
    CacheHelper.saveData("CodeForce", Code);

    emit(LoadingGetClinicState());

    try {
      Response response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(Code, CacheHelper.getData('phone')),
        language: true,
      );
      if (isFilter) {
        vetClientModel = List<VetClientModel>.from(
                response.data["data"].map((x) => VetClientModel.fromJson(x)))
            .where((element) => element.addedInSqueakStatues == false)
            .toList();
      } else {
        vetClientModel = List<VetClientModel>.from(
                response.data["data"].map((x) => VetClientModel.fromJson(x)))
            .toList();
      }
      isGetVet = true;
      emit(SuccessGetClinicState());
    } on DioException catch (e) {
      isGetVet = false;
      emit(ErrorGetClinicState());
      print(e.response);
    }
  }

  bool isGetClinic = true;

  Future getClientInapp(String Code) async {
    getTokenFormFirebase();
    emit(LoadingGetClientState());
    try {
      String username = Username ?? 'Ahmed.Omar@Veticare.com';
      String passwordBasic = password ?? 'Password@123';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$passwordBasic'));
      var dio = Dio();
      Response response = await dio.request(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/${CacheHelper.getData('phone')}/$Code',
        options: Options(
          method: 'GET',
          headers: {
            'accept': '*/*',
            'Authorization': basicAuth,
          },
        ),
      );
      dio.interceptors.add(ChuckerDioInterceptor());
      vetClientModelOne = DataVet.fromJson(response.data['data']);
      phoneController.text = vetClientModelOne!.phone;
      emailController.text = vetClientModelOne!.email;
      print(emailController.text + '***********************');
      emit(SuccessGetClientState());
    } on DioException catch (e) {
      print(e.response);
      isGetClinic = false;
      emit(ErrorGetClientState());
    }
  }

  bool isAccept = false;
  bool isFollowBefore = false;

  Future acceptIvation({
    required String clinicCode,
    required String clientId,
    required String squeakUserId,
  }) async {
    isAccept = true;
    emit(LoadingAcceptIvationState());
    try {
      await DioFinalHelper.putData(
        method: acceptInvitation,
        data: {
          "clientId": clientId,
          "clinicCode": clinicCode,
          "squeakUserId": squeakUserId,
        },
      );
      isAccept = false;
      getClintFormVetVoidT(clinicCode, false).then(
        (value) {
          if (value.first.id.contains('0000')) {
            emit(SuccessAcceptIvationState(false));
          } else {
            emit(SuccessAcceptIvationState(true));
          }
        },
      );
    } on DioException catch (e) {
      isAccept = false;
      emit(ErrorAcceptIvationState(ResponseModel.fromJson(e.response?.data)));
      print(e);
    }
  }

  Future<List<VetClientModel>> getClintFormVetVoidT(
      String code, bool isFilter) async {
    try {
      Response response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(code, CacheHelper.getData('phone')),
        language: true,
      );

      // Filter or map the response data based on the 'isFilter' flag
      if (isFilter) {
        vetClientModel = List<VetClientModel>.from(
                response.data["data"].map((x) => VetClientModel.fromJson(x)))
            .where((element) => element.addedInSqueakStatues == false)
            .toList();
      } else {
        vetClientModel = List<VetClientModel>.from(
                response.data["data"].map((x) => VetClientModel.fromJson(x)))
            .toList();
      }
      isGetVet = true;
      return vetClientModel;
    } on DioException catch (e) {
      isGetVet = false;
      print(e);
      return []; // Return an empty list in case of an error
    }
  }

  bool isAddInSqueakStatues = false;
  bool isLinkInSqueakStatues = false;
  Future addInSqueakStatues({
    required String vetCarePetId,
    String? squeakPetId,
    required int statuesOfAddingPetToSqueak,
  }) async {
    if (squeakPetId == null) {
      isAddInSqueakStatues = true;
    } else {
      isLinkInSqueakStatues = true;
    }
    emit(LoadingAddInSqueakStatuesState());
    try {
      await DioFinalHelper.postData(
        method: mergePetFormVet,
        data: statuesOfAddingPetToSqueak == 2
            ? {
                "vetCarePetId": vetCarePetId,
                "squeakPetId": squeakPetId,
                "statuesOfAddingPetToSqueak": 2
              }
            : {
                "vetCarePetId": vetCarePetId,
                "statuesOfAddingPetToSqueak": 1,
              },
      );
      if (squeakPetId == null) {
        isAddInSqueakStatues = false;
      } else {
        isLinkInSqueakStatues = false;
      }
      emit(SuccessAddInSqueakStatuesState(vetCarePetId));
    } on DioException catch (e) {
      isAddInSqueakStatues = false;
      isAddInSqueakStatues = false;
      emit(ErrorAddInSqueakStatuesState(
          ResponseModel.fromJson(e.response?.data)));
      print(e);
    }
  }

  @override
  Future<void> close() {
    print('close Cubit');
    CacheHelper.removeData('NotificationId');
    CacheHelper.removeData('NotificationType');

    return super.close();
  }
}
