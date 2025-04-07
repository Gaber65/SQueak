import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/helper/image_helper/helper_model/response_model.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';

import '../../../../core/helper/remotely/dio.dart';
import '../../../vetcare/models/vetIcare_client_model.dart';
import '../../models/clinic_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  final TextEditingController searchController = TextEditingController();

  List<Clinic> searchList = [];
  bool isFollowBefore = false;
  Future<void> getSearchList() async {
    emit(SearchLoading());
    print("start search");
    try {
      Response response = await DioFinalHelper.getData(
        method: addClinicEndPoint + '?Code=${searchController.text}',
        language: false,
      );
      searchList = (response.data['data']['clinics'] as List)
          .map((e) => Clinic.fromJson(e))
          .toList();
      if (suppliers != null && searchList.isNotEmpty) {
        ClinicInfo? clinic = findClinic(suppliers!.data, searchList[0].code);
        if (clinic != null) {
          isFollowBefore = true;
        }
      }

      emit(SearchSuccess());
    } on DioException catch (e) {
      print("out from search");
      print(e.response!.data);
      emit(SearchError());
    }
  }

  Future followClinic(clinicId, BuildContext context) async {
    print('Process started: followClinic for clinicId: $clinicId');
    emit(FollowLoading());

    try {
      print('Calling DioFinalHelper.postData...');
      await DioFinalHelper.postData(
        method: followClinicEndPoint,
        data: {
          "clinicId": clinicId,
        },
      );

      print('Calling getClintFormVetVoid with searchController text...');
      getClintFormVetVoid(searchController.text, false).then(
        (value) {
          print('Received response from getClintFormVetVoid: $value');
          if (value.isNotEmpty) {
            if (value.first.id.contains('0000')) {
              print('Client ID contains 0000, emitting FollowSuccess(false)');
              emit(FollowSuccess(false));
            } else {
              print('Client ID valid, emitting FollowSuccess(true)');
              emit(FollowSuccess(true));
            }
          } else {
            print('Empty response, emitting FollowSuccess(false)');
            emit(FollowSuccess(false));
          }
        },
      );
    } on DioException catch (e) {
      print('DioError caught: ${e.response!.data}');
      emit(FollowError(ResponseModel.fromJson(e.response!.data)));
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

  Future unfollowClinic(clinicId) async {
    emit(FollowLoading());
    try {
      await DioFinalHelper.postData(
        method: unfollowClinicEndPoint,
        data: {
          "clinicId": clinicId,
        },
      );
      emit(FollowSuccess(false));
    } on DioException catch (e) {
      print("Show me");
      print(e.response!.data);
      emit(FollowError(ResponseModel.fromJson(e.response!.data)));
    }
  }

  void init() {
    getSupplier();
  }

  MySupplierModel? suppliers;

  Future<void> getSupplier() async {
    emit(GetSupplierLoading());
    try {
      Response response = await DioFinalHelper.getData(
        method: getFollowerClinicEndPoint,
        language: false,
      );
      suppliers = MySupplierModel.fromJson(response.data['data']);
      emit(GetSupplierSuccess());
    } on DioException catch (e) {
      print(e);
      emit(GetSupplierError());
    }
  }

  ClinicInfo? findClinic(List<ClinicInfo> data, String clinicId) {
    print('clinicId $clinicId');
    for (var element in data) {
      if (element.data.code == clinicId) {
        return element;
      }
    }
    return null;
  }
}
