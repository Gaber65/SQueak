import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'dart:io';
import 'package:squeak/core/utils/firebase_token_helper.dart';

import 'package:squeak/features/auth/register/data/models/country_model.dart';
import 'package:squeak/features/auth/login/data/models/auth_model.dart';

import '../../../../vetcare/data/models/vet_client_model.dart';

class RegisterRemoteDataSource {
  String? password;
  String? username;

  Future<void> getTokenFormFirebase() async {
    try {
      FirebaseFirestore.instance
          .collection('UserToken')
          .doc('Is0fJjcbMCqOrWmQdKoj')
          .snapshots()
          .listen((event) {
            username = event.data()!['Username'];
            password = event.data()!['password'];
          });
    } on Exception {
      // print(e);
    }
  }

  Future<List<CountryModel>> getCountry(String name) async {
    await getTokenFormFirebase();
    try {
      final auth =
          'Basic ${base64Encode(utf8.encode('${username ?? "Ahmed.Omar@Veticare.com"}:${password ?? "Password@123"}'))}';
      final dio = Dio();
      final response = await dio.request(
        '${ConfigModel.baseApiUrlSqueak}$version/squeak/countries?Name=$name',
        options: Options(
          method: 'GET',
          headers: {'accept': '*/*', 'Authorization': auth},
        ),
      );

      return (response.data['data'] as List)
          .map((e) => CountryModel.fromJson(e))
          .where((e) => e.id != 2)
          .toList();
    } on DioException {
      // print(e.response);
      rethrow;
    }
  }

  Future<AuthModel> register(Map<String, dynamic> data) async {
    try {
      // Attach Firebase token and platform flags to registration payload
      final fbToken = await FirebaseTokenHelper.getFirebaseToken() ??
          'fallback_token_${DateTime.now().millisecondsSinceEpoch}';

      final enhancedData = {
        ...data,
        'FbToken': fbToken,
        'IOSDevice': Platform.isIOS,
        'Androidevice': Platform.isAndroid,
      };

  // print('[RegisterRemote] Sending register payload with FbToken and device flags: FbToken=${fbToken.substring(0, 8)}... IOSDevice=${Platform.isIOS} Androidevice=${Platform.isAndroid}');

      final response = await DioFinalHelper.postData(method: registerEndPoint, data: enhancedData);

      // The register endpoint returns the same shape as login (AuthModel-like).
      // Parse and return it so callers can handle tokens/user info similarly to login.
      final authModel = AuthModel.fromJson(response.data);
      print('[RegisterRemote] Received auth-like response from register: token=${authModel.data?.token ?? 'null'} id=${authModel.data?.id}');
      return authModel;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  Future<AuthModel> registerQr(Map<String, dynamic> data) async {
    try {
      // Attach Firebase token and platform flags to QR registration payload
      final fbToken = await FirebaseTokenHelper.getFirebaseToken() ??
          'fallback_token_${DateTime.now().millisecondsSinceEpoch}';

      final enhancedData = {
        ...data,
        'FbToken': fbToken,
        'IOSDevice': Platform.isIOS,
        'Androidevice': Platform.isAndroid,
      };

  // print('[RegisterRemote][QR] Sending registerQr payload with FbToken and device flags: FbToken=${fbToken.substring(0, 8)}... IOSDevice=${Platform.isIOS} Androidevice=${Platform.isAndroid}');

      final response = await DioFinalHelper.putData(method: registerQrEndPoint, data: enhancedData);

      final authModel = AuthModel.fromJson(response.data);
      print('[RegisterRemote][QR] Received auth-like response from registerQr: token=${authModel.data?.token ?? 'null'} id=${authModel.data?.id}');
      return authModel;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  Future<List<VetClientModel>> getClients(
    String code,
    String phone,
    bool isFilter,
  ) async {
    final response = await DioFinalHelper.getData(
      method: getClientClinicEndPoint(code, phone),
      language: true,
    );

    final list = List<VetClientModel>.from(
      response.data["data"].map((x) => VetClientModel.fromJson(x)),
    );

    if (isFilter) {
      return list.where((e) => e.addedInSqueakStatues == false).toList();
    }

    return list;
  }
}
