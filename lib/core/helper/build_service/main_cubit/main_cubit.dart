import 'dart:async';
import 'dart:io';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/helper/remotely/dio.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/vetcare/view/vetCareRegister.dart';

import '../../../../features/vetcare/models/vetIcare_client_model.dart';
import '../../image_helper/helper_model/helper_model.dart';
import '../../remotely/config_model.dart';
import '../../remotely/end-points.dart';
import '../firebase_service.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  String? language;

  void changeAppLang({
    String? fromSharedLang,
    String? langMode,
  }) {
    if (fromSharedLang != null) {
      language = fromSharedLang;

      setLangInAPI(fromSharedLang == 'ar' ? 1 : 0);
      emit(AppChangeModeState());
    } else {
      language = langMode;
      setLangInAPI(language == 'ar' ? 1 : 0);

      CacheHelper.saveData(
        'language',
        langMode!,
      ).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  void setLangInAPI(int lang) async {
    print('lang: $lang');
    try {
      await DioFinalHelper.putData(method: updateapplangauge, data: {
        "language": lang,
      });
      emit(AppChangeModeState());
    } on DioException catch (e) {
      print(e.toString());
      print(e.response);
    }
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeFromSharedState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(
        'isDark',
        isDark,
      );
      print(isDark);
      print(CacheHelper.getData('isDark'));
      emit(AppChangeModeState());
    }
  }

  bool isAllowNotification = true;

  Future<void> deleteToken() async {
    isAllowNotification = false;
    emit(DeleteTokenLoading()); // Emit loading state for feedback
    await FirebaseMessaging.instance.deleteToken().then((value) {
      CacheHelper.saveData('isAllowNotification', isAllowNotification);
      emit(DeleteTokenSuccess()); // Update state to reflect changes
    });
  }

  Future<void> getIsAllowNotification() async {
    isAllowNotification = CacheHelper.getData('isAllowNotification') ?? true;
    emit(SaveTokenSuccess()); // Update state to reflect changes
  }

  Future<void> saveToken() async {
    if (CacheHelper.getData('isAllowNotification') == null ||
        CacheHelper.getData('isAllowNotification') == true) {
      emit(SaveTokenLoading()); // Emit loading state for feedback

      // try {
      //   await DioFinalHelper.postData(
      //     method: sendtoken,
      //     data: {
      //       "fbToken": CacheHelper.getData('DeviceToken') ??
      //           await FirebaseMessaging.instance.getToken(),
      //     },
      //   );
      //   CacheHelper.saveData('isAllowNotification', isAllowNotification);
      //   emit(SaveTokenSuccess()); // Update state to reflect changes
      // } catch (e) {
      //   print(e.toString());
      //   emit(SaveTokenError());
      // }
    }
  }

  Future<void> requestNotificationPermissions() async {
    isAllowNotification = true;

    emit(SaveTokenSuccess()); // Update state to reflect changes
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final token = await FirebaseMessaging.instance.getToken();
    CacheHelper.saveData('DeviceToken', token);
    CacheHelper.saveData('isAllowNotification', isAllowNotification);
    print("token ${await FirebaseMessaging.instance.getToken()}");
    emit(SaveTokenSuccess()); // Update state to reflect changes
  }

  Future removeToken() async {
    emit(SaveTokenLoading());

    if (CacheHelper.getData('DeviceToken') != null) {
      try {
        await DioFinalHelper.deleteData(
          method: sendtoken,
          data: {
            "fbToken": CacheHelper.getData('DeviceToken'),
          },
        );
        emit(SaveTokenSuccess());
      } on DioException catch (e) {
        print(e.toString());
        print(e.response);
        emit(SaveTokenError());
      }
    } else {
      print('no token');
      emit(SaveTokenError());
    }
  }

  HelperModel? modelImage;

  Future<void> getGlobalImage({
    required File file,
    required int uploadPlace,
  }) async {
    String fileName = file.path.split('/').last;
    String filePath = file.path;
    emit(ImageHelperLoading());

    try {
      // Compress the image
      File compressedFile = await _compressImage(file);

      // Get the path of the compressed file
      String compressedFilePath = compressedFile.path;

      // Send the compressed image to the API
      final response = await DioFinalHelper.postData(
        method: imageHelperEndPoint,
        data: FormData.fromMap({
          "File": await MultipartFile.fromFile(
            compressedFilePath,
            filename: fileName,
            contentType: MediaType("image", "jpeg"),
          ),
          'UploadPlace': '$uploadPlace',
        }),
      );

      modelImage = HelperModel.fromJson(response.data);
      emit(ImageHelperSuccess(HelperModel.fromJson(response.data)));
      print(modelImage!.data);
    } on DioException catch (e) {
      // Handling Dio exceptions
      print('Other error: ${e.response}');
      emit(ImageHelperError());
    }
  }

// Compress the image before sending
  Future<File> _compressImage(File file) async {
    // Compress the image
    final result = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 800, // minimum width for compressed image
      minHeight: 800, // minimum height for compressed image
      quality: 50, // compression quality (0-100)
    );

    // Create a new file with the compressed data
    final compressedFile = File(file.path)..writeAsBytesSync(result!);
    return compressedFile;
  }

  HelperModel? modelVideo;

  Future<void> getGlobalVideo({
    required File file,
    required int uploadPlace,
  }) async {
    String fileName = file.path.split('/').last;
    String filePath = file.path;
    emit(ImageHelperLoading());
    final dio = await Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 30),
        receiveDataWhenStatusError: true,
        baseUrl: '${ConfigModel.baseApiUrlSqueak}$version',
        headers: {
          'Authorization': 'Bearer ${CacheHelper.getData('refreshToken')}',
          // 'Content-Type': 'multipart/form-data'
        },
      ),
    ).post(
      videoHelperEndPoint,
      data: FormData.fromMap({
        "File": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: new MediaType("video", "mp4"), //add this
        ),
        'UploadPlace': '$uploadPlace'
      }),
      onReceiveProgress: (count, total) {
        print('$count , $total');
      },
    ).then((value) {
      modelVideo = HelperModel.fromJson(value.data);
      emit(ImageHelperSuccess(HelperModel.fromJson(value.data)));
      print(modelVideo!.data);
    }).catchError((onError) {
      print("******************$onError********************");
      emit(ImageHelperError());
    });
  }

  HelperModel? modelSound;

  Future<void> getGlobalSound({
    required File file,
    required int uploadPlace,
  }) async {
    String fileName = file.path.split('/').last;
    String filePath = file.path;
    emit(ImageHelperLoading());
    try {
      final dio = await Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 30),
          receiveDataWhenStatusError: true,
          baseUrl: '${ConfigModel.baseApiUrlSqueak}$version',
          headers: {
            'Authorization': 'Bearer ${CacheHelper.getData('refreshToken')}',
            // 'Content-Type': 'multipart/form-data'
          },
        ),
      ).post(
        audioHelperEndPoint,
        data: FormData.fromMap({
          "File": await MultipartFile.fromFile(
            filePath,
            filename: fileName,
            contentType: new MediaType(
              "audio",
              "Acc",
            ), //add this
          ),
          'UploadPlace': '$uploadPlace'
        }),
        onReceiveProgress: (count, total) {
          print('$count , $total');
        },
      );
      modelSound = HelperModel.fromJson(dio.data);
      emit(ImageHelperSuccess(HelperModel.fromJson(dio.data)));
      print(modelSound!.data);
    } on DioException catch (error) {
      emit(ImageHelperError());
      print(error.response);
    }
  }

  bool isGetVet = false;
  List<VetClientModel> vetClientModel = [];

  Future<List<VetClientModel>> getClintFormVetVoid(
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
    } on Exception catch (e) {
      isGetVet = false;
      print(e);
      return []; // Return an empty list in case of an error
    }
  }
}

enum UploadPlace {
  postImages(1),
  petsImages(2),
  uploads(3),
  usersImages(4),
  postVideos(5),
  commentImages(6),
  clinicImage(7),
  messageImage(8),
  messageRecord(9);

  final int value;

  const UploadPlace(this.value);
}
