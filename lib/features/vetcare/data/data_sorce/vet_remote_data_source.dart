import 'dart:convert';
import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squeak/features/auth/login/data/models/login_data_model.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../models/data_vet_model.dart';
import '../models/vet_client_model.dart';
import 'base_vet_data_source.dart';

class VetRemoteDataSource implements BaseVetRemoteDataSource {
  VetRemoteDataSource();

  String? _username;
  String? _password;

  @override
  Future<List<VetClientModel>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String clientId,
    required String birthDate,
    required int gender,
    required String clinicCode,
    required int countryId,
  }) async {
    try {
      final response = await DioFinalHelper.postData(
        method: vetIcareReigster,
        data: {
          "fullName": fullName,
          "email": email,
          "fbToken": 'device_token', // Replace with actual token
          "userName": email,
          "password": password,
          "passwordConfirm": password,
          "userType": 1,
          "phone": phone,
          "clientId": clientId,
          "birthDate": birthDate,
          "gender": gender,
          "clinicCode": clinicCode,
          "CountryId": countryId,
        },
      );

      return List<VetClientModel>.from(
        response.data["data"].map((x) => VetClientModel.fromJson(x)),
      ).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginData> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final fbToken =
        CacheHelper.getData('DeviceToken') ??
        await FirebaseMessaging.instance.getToken();
    try {
      final response = await DioFinalHelper.postData(
        method: loginEndPoint,
        data: {
          'emailOrPhoneNumber': emailOrPhone,
          'Password': password,
          'FbToken': fbToken,
          'IOSDevice': Platform.isIOS,
          'Androidevice': Platform.isAndroid,
        },
      );

      // Return token or user ID
      return LoginData.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataVetModel> getClient(String invitationCode) async {
    await _getTokenFromFirebase();

    try {
      final basicAuth = _createBasicAuth();
      final dioWithInterceptor =
          Dio()..interceptors.add(ChuckerDioInterceptor());

      final response = await dioWithInterceptor.get(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/$invitationCode',
        options: Options(headers: _createAuthHeaders(basicAuth)),
      );

      return DataVetModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataVetModel> getClientInApp(String code, String phone) async {
    await _getTokenFromFirebase();

    try {
      final basicAuth = _createBasicAuth();
      final dioWithInterceptor =
          Dio()..interceptors.add(ChuckerDioInterceptor());

      final response = await dioWithInterceptor.get(
        '${ConfigModel.baseApiUrlSqueak}$version/vetcare/client/$phone/$code',
        options: Options(headers: _createAuthHeaders(basicAuth)),
      );

      return DataVetModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getClinicById(String id) async {
    try {
      final response = await DioFinalHelper.getData(
        method: '$addClinicEndPoint/$id',
        language: true,
      );

      return response.data['data']['clinic'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<VetClientModel>> getClientsFromVet(
    String code,
    String phone,
    bool isFilter,
  ) async {
    try {
      final response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(code, CacheHelper.getData('phone')),
        language: true,
      );

      final clients = List<VetClientModel>.from(
        response.data["data"].map((x) => VetClientModel.fromJson(x)),
      );

      if (isFilter) {
        clients.removeWhere((element) => element.addedInSqueakStatues == true);
      }

      return clients;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> addInSqueakStatues({
    required String vetCarePetId,
    String? squeakPetId,
    required int statuesOfAddingPetToSqueak,
  }) async {
    try {
      final data =
          statuesOfAddingPetToSqueak == 2
              ? {
                "vetCarePetId": vetCarePetId,
                "squeakPetId": squeakPetId,
                "statuesOfAddingPetToSqueak": 2,
              }
              : {"vetCarePetId": vetCarePetId, "statuesOfAddingPetToSqueak": 1};

      await DioFinalHelper.postData(method: mergePetFormVet, data: data);

      return vetCarePetId;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> acceptInvitation({
    required String clinicCode,
    required String clientId,
    required String squeakUserId,
  }) async {
    try {
      await DioFinalHelper.putData(
        method: acceptInvitationEndPoint,
        data: {
          "clientId": clientId,
          "clinicCode": clinicCode,
          "squeakUserId": squeakUserId,
        },
      );

      // Get clients to check if successful
      final clients = await getClientsFromVet(clinicCode, 'phone', false);
      return !clients.first.id.contains('0000');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getNotifications(String id) async {
    try {
      final response = await DioFinalHelper.getData(
        method: '$version/notifications',
        language: true,
      );

      final notifications = [];
      if (response.data['data']['notificationDtos'] != null) {
        notifications.addAll(response.data['data']['notificationDtos']);

        // Check if we need to update a specific notification
        for (final element in notifications) {
          if (element['notificationEvents'].isNotEmpty &&
              element['notificationEvents'][0]['id'] == id) {
            await updateNotificationState(id);
            break;
          }
        }
      }

      return notifications;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateNotificationState(String id) async {
    try {
      await DioFinalHelper.putData(
        method: '$version/notifications/$id',
        data: {},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Helper methods
  Future<void> _getTokenFromFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserToken')
          .doc('Is0fJjcbMCqOrWmQdKoj')
          .snapshots()
          .listen((event) {
            _username = event.data()?['Username'];
            _password = event.data()?['password'];
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _createBasicAuth() {
    final authUser = _username ?? 'Ahmed.Omar@Veticare.com';
    final authPass = _password ?? 'Password@123';
    return 'Basic ${base64Encode(utf8.encode('$authUser:$authPass'))}';
  }

  Map<String, String> _createAuthHeaders(String auth) {
    return {'accept': '*/*', 'Authorization': auth};
  }
}
