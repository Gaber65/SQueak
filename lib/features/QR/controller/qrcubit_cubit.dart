import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/vetcare/models/vetIcare_client_model.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../layout/models/clinic_model.dart';
import 'qrcubit_state.dart';

class QRCubit extends Cubit<QRState> {
  QRCubit() : super(QRInitial());

  static QRCubit get(context) => BlocProvider.of(context);

  MySupplierModel? suppliers;
  bool isAlreadyFollow = false;
  int countdown = 5;
  bool isLoading = true;

  Future<void> getSupplier(String clinicCode) async {
    emit(QRLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method: getFollowerClinicEndPoint,
        language: false,
      );

      suppliers = MySupplierModel.fromJson(response.data['data']);
      checkClinicInMySupplier(clinicCode);
    } catch (e) {
      emit(QRError(e.toString()));
    }
  }

  void checkClinicInMySupplier(String clinicCode) {
    if (suppliers != null && suppliers!.data.isNotEmpty) {
      isAlreadyFollow =
          suppliers!.data.any((element) => element.data.code == clinicCode);
    } else {
      isAlreadyFollow = false;
    }
    isLoading = false;
    emit(QRLoaded(isAlreadyFollow: isAlreadyFollow));
  }

  bool isConfirmed = false;
  Future<void> followClinic(String clinicCode) async {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (countdown > 0) {
          countdown--;
          emit(QRFollowing());
        } else {
          timer.cancel();
          emit(QRFollowing());
        }
      },
    );
    emit(QRFollowing());
    try {
      await DioFinalHelper.postData(
        method: followQrEndPoint,
        data: {
          "clinicCode": clinicCode,
          "allToShareDataWithVetICare": true,
        },
      );
      isConfirmed = true;
      getClintFormVetVoid(clinicCode, false).then(
        (value) {
          if (value.isNotEmpty) {
            if (value.first.id.contains('0000')) {
              emit(FollowSuccess(false));
            } else {
              emit(FollowSuccess(true));
            }
          } else {
            emit(FollowSuccess(false));
          }
        },
      );
      emit(QRFollowed());
    } catch (e) {
      emit(QRError(e.toString()));
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

      isGetVet = true;
      return vetClientModel;
    } on DioException {
      isGetVet = false;
      emit(FollowSuccess(false));

      return []; // Return an empty list in case of an error
    }
  }
}
