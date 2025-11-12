import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:squeak/features/mating/profile/data/models/history_model.dart';
import 'package:squeak/features/mating/profile/domain/usecases/mating_profile_prams.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/history_entities.dart';

abstract class MatingProfileDataSource {
  Future<void> updatePetStatus(MatingProfileParams params);
  Future<PetData> getPetDate(String petId);
  Future<List<HistoryModel>> getPetDateHistory(String petId);
}

class MatingProfileDataSourceImpl implements MatingProfileDataSource {
  @override
  Future<void> updatePetStatus(MatingProfileParams params) async {
    try {
      String endpoint;
      final statusValue = params.status.toApiValue;
      
      switch (params.status) {
        case HistoryStatus.separated:
          endpoint = '${getPetHistoryProfileSeperate(params.historyId)}?status=$statusValue';
          break;
        case HistoryStatus.pregnant:
          endpoint = '${getPetHistoryProfilePregnant(params.historyId)}?status=$statusValue';
          break;
        case HistoryStatus.hasBaby:
          endpoint = '${getPetHistoryProfileSetBaby(params.historyId)}?status=$statusValue';
          break;
        case HistoryStatus.availableForMating:
        case HistoryStatus.notAvailable:
        case HistoryStatus.single:
        case HistoryStatus.married:
        case HistoryStatus.discovered:
        case HistoryStatus.mating:
        case HistoryStatus.inMatingProcess:
          endpoint = '$updatePetStatusEndPoint${params.petId}?status=$statusValue';
          break;
      }

      // debug: print final endpoint and request body
      final requestData = <String, dynamic>{};
      try {
        // print url and request payload (empty map for now)
        // using jsonEncode ensures consistent formatting in logs
        print('UPDATE PET STATUS REQUEST -> url: $endpoint');
        print('UPDATE PET STATUS REQUEST -> body: ${jsonEncode(requestData)}');
      } catch (_) {
        // ignore logging errors
      }

      final result = await DioFinalHelper.putData(method: endpoint, data: requestData);
      print('UPDATE PET STATUS RESPONSE -> statusCode: [32m${result.statusCode}[0m');
      return result.data;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<PetData> getPetDate(String petId) async {
    try {
      final result = await DioFinalHelper.getData(method: getPetProfile(petId));
      return PetData.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<List<HistoryModel>> getPetDateHistory(String petId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: getPetHistoryProfile(petId),
      );
      final list =
          (result.data['data']['result'] as List)
              .map((e) => HistoryModel.fromJson(e))
              .toList();
      return list;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }
}
