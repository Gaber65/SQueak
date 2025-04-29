import 'dart:convert';
import 'dart:io';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squeak/features/authentication/models/login.dart';
import 'package:squeak/features/vetcare/models/vetIcare_client_model.dart';

import '../../layout/models/clinic_model.dart';
import '../../layout/notification/NotificationAPI/data/model/Notification_model.dart';

part 'vet_state.dart';

class VetCubit extends Cubit<VetState> {
  VetCubit() : super(VetInitial());

  static VetCubit get(context) => BlocProvider.of(context);

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State variables
  bool isRegister = false;
  bool isGetVet = false;
  bool isGetClinic = true;
  bool isAccept = false;
  bool isFollowBefore = false;
  bool isAddInSqueakStatues = false;
  bool isLinkInSqueakStatues = false;

  String? password;
  String? Username;

  DataVet? vetClientModelOne;
  Clinic? entities;
  File? profileImage;

  final ImagePicker picker = ImagePicker();
  final List<NotificationModel> notifications = [];
  final List<VetClientModel> vetClientModel = [];

  //region Original Methods (with improved internals)
  Future<void> register() async {
    isRegister = true;
    emit(LoadingRegisterState());

    try {
      final phone = normalizePhoneNumber(phoneController.text);
      debugPrint(phone);

      final response = await DioFinalHelper.postData(
        method: vetIcareReigster,
        data: _buildRegistrationData(phone),
      );

      final clients =
          List<VetClientModel>.from(
            response.data["data"].map((x) => VetClientModel.fromJson(x)),
          ).toList();

      CacheHelper.removeData('invitationCode');

      // Maintain original login logic
      if (clients.first.id.contains('0000')) {
        login(false);
      } else {
        login(true);
      }

      emit(SuccessRegisterState());
    } on DioException catch (e) {
      isRegister = false;
      emit(ErrorRegisterState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  Map<String, dynamic> _buildRegistrationData(String phone) {
    return {
      "fullName": vetClientModelOne?.name ?? '',
      "email": emailController.text,
      "fbToken": CacheHelper.getData('DeviceToken') ?? 'sdsdsd',
      "userName": emailController.text,
      "password": passwordController.text,
      "passwordConfirm": passwordController.text,
      "userType": 1,
      "phone": phone,
      "clientId": vetClientModelOne?.vetICareId ?? '',
      "birthDate": birthDateController.text,
      "gender": 1,
      "clinicCode": vetClientModelOne?.clinicCode ?? '',
      "CountryId": vetClientModelOne?.countryId ?? 0,
    };
  }

  Future<void> login(bool isHavePet) async {
    emit(LoadingLoginState());

    try {
      final response = await DioFinalHelper.postData(
        method: loginEndPoint,
        data: {
          'emailOrPhoneNumber': vetClientModelOne?.phone ?? '',
          'Password': passwordController.text,
        },
      );

      isRegister = false;
      emit(SuccessLoginState(AuthModel.fromJson(response.data), isHavePet));
    } on DioException catch (e) {
      isRegister = false;
      debugPrint(e.response.toString());
      emit(ErrorLoginState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  Future getNotifications(id) async {
    emit(NotificationsLoadingState());

    try {
      final response = await DioFinalHelper.getData(
        method: '$version/notifications',
        language: true,
      );

      _processNotifications(response, id);
      emit(NotificationsSuccessState());
    } on DioException catch (e) {
      debugPrint(e.response!.data.toString());
      emit(NotificationsErrorState());
    }
  }

  void _processNotifications(Response response, String id) {
    notifications.clear();

    if (response.data['data']['notificationDtos'] != null) {
      notifications.addAll(
        (response.data['data']['notificationDtos'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList(),
      );

      CacheHelper.saveData('notificationsNum', notifications.length);

      for (final element in notifications) {
        if (element.notificationEvents.isNotEmpty &&
            element.notificationEvents[0].id == id) {
          updateState(element.notificationEvents[0].id);
          break;
        }
      }
    }
  }

  Future updateState(id) async {
    emit(NotificationsLoadingState());

    try {
      await DioFinalHelper.putData(
        method: '$version/notifications/$id',
        data: {},
      );
      emit(NotificationsSuccessState());
    } on DioException catch (e) {
      debugPrint(e.response!.data.toString());
      emit(NotificationsErrorState());
    }
  }

  Future getClient(String invitationCode) async {
    getTokenFormFirebase();
    emit(LoadingGetClientState());

    try {
      final basicAuth = _createBasicAuth();
      final dio = Dio()..interceptors.add(ChuckerDioInterceptor());

      final response = await dio.get(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/$invitationCode',
        options: Options(headers: _createAuthHeaders(basicAuth)),
      );

      _processClientResponse(response);
      emit(SuccessGetClientState());
    } on DioException catch (e) {
      debugPrint(e.response.toString());
      emit(ErrorGetClientState());
    }
  }

  String _createBasicAuth() {
    final authUser = Username ?? 'Ahmed.Omar@Veticare.com';
    final authPass = password ?? 'Password@123';
    return 'Basic ${base64Encode(utf8.encode('$authUser:$authPass'))}';
  }

  Map<String, String> _createAuthHeaders(String auth) {
    return {'accept': '*/*', 'Authorization': auth};
  }

  void _processClientResponse(Response response) {
    vetClientModelOne = DataVet.fromJson(response.data['data']);
    phoneController.text = vetClientModelOne!.phone;
    emailController.text = vetClientModelOne!.email;
    debugPrint(emailController.text + '***********************');
  }

  Future getTokenFormFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserToken')
          .doc('Is0fJjcbMCqOrWmQdKoj')
          .snapshots()
          .listen((event) {
            debugPrint(event.data().toString());
            Username = event.data()!['Username'];
            password = event.data()!['password'];
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getPitsImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  Future getClinicbyID(id) async {
    emit(LoadingGetClinicState());

    try {
      final response = await DioFinalHelper.getData(
        method: addClinicEndPoint + '/' + id,
        language: true,
      );

      entities = Clinic.fromJson(response.data['data']['clinic']);
      await getClientInapp(entities!.code);
      emit(SuccessGetClinicState());
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(ErrorGetClinicState());
    }
  }

  Future getClintFormVetVoid(String Code, bool isFilter) async {
    CacheHelper.saveData("CodeForce", Code);
    emit(LoadingGetClinicState());

    try {
      final response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(Code, CacheHelper.getData('phone')),
        language: true,
      );

      _processVetClients(response, isFilter);
      emit(SuccessGetClinicState());
    } on DioException catch (e) {
      isGetVet = false;
      debugPrint(e.response.toString());
      emit(ErrorGetClinicState());
    }
  }

  void _processVetClients(Response response, bool isFilter) {
    vetClientModel.clear();
    vetClientModel.addAll(
      List<VetClientModel>.from(
        response.data["data"].map((x) => VetClientModel.fromJson(x)),
      ),
    );

    if (isFilter) {
      vetClientModel.removeWhere(
        (element) => element.addedInSqueakStatues == true,
      );
    }

    isGetVet = true;
  }

  Future getClientInapp(String Code) async {
    getTokenFormFirebase();
    emit(LoadingGetClientState());

    try {
      final basicAuth = _createBasicAuth();
      final dio = Dio()..interceptors.add(ChuckerDioInterceptor());

      final response = await dio.get(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/${CacheHelper.getData('phone')}/$Code',
        options: Options(headers: _createAuthHeaders(basicAuth)),
      );

      _processClientResponse(response);
      emit(SuccessGetClientState());
    } on DioException catch (e) {
      debugPrint(e.response.toString());
      isGetClinic = false;
      emit(ErrorGetClientState());
    }
  }

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
      final clients = await getClintFormVetVoidT(clinicCode, false);

      if (clients.first.id.contains('0000')) {
        emit(SuccessAcceptIvationState(false));
      } else {
        emit(SuccessAcceptIvationState(true));
      }
    } on DioException catch (e) {
      isAccept = false;
      debugPrint(e.toString());
      emit(ErrorAcceptIvationState(ErrorMessageModel.fromJson(e.response?.data)));
    }
  }

  Future<List<VetClientModel>> getClintFormVetVoidT(
    String code,
    bool isFilter,
  ) async {
    try {
      final response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(code, CacheHelper.getData('phone')),
        language: true,
      );

      _processVetClients(response, isFilter);
      return vetClientModel;
    } on DioException catch (e) {
      isGetVet = false;
      debugPrint(e.toString());
      return [];
    }
  }

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
        data: _buildSqueakStatusData(
          vetCarePetId,
          squeakPetId,
          statuesOfAddingPetToSqueak,
        ),
      );

      isAddInSqueakStatues = false;
      isLinkInSqueakStatues = false;
      emit(SuccessAddInSqueakStatuesState(vetCarePetId));
    } on DioException catch (e) {
      isAddInSqueakStatues = false;
      isLinkInSqueakStatues = false;
      debugPrint(e.toString());
      emit(
        ErrorAddInSqueakStatuesState(ErrorMessageModel.fromJson(e.response?.data)),
      );
    }
  }

  Map<String, dynamic> _buildSqueakStatusData(
    String vetCarePetId,
    String? squeakPetId,
    int status,
  ) {
    return status == 2
        ? {
          "vetCarePetId": vetCarePetId,
          "squeakPetId": squeakPetId,
          "statuesOfAddingPetToSqueak": 2,
        }
        : {"vetCarePetId": vetCarePetId, "statuesOfAddingPetToSqueak": 1};
  }

  @override
  Future<void> close() {
    debugPrint('close Cubit');
    CacheHelper.removeData('NotificationId');
    CacheHelper.removeData('NotificationType');
    return super.close();
  }
}
