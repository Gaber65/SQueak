import 'package:dio/dio.dart';
import 'package:squeak/features/mating/feeds/domain/usecases/mating_parameters.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';


abstract class PetMatingRemoteDataSource {
  Future<List<PetData>> getAvailablePets(String specieId);
  Future<String> sendMatingRequest(SendMatingRequestParameters parameters);
  Future<void> updateSentRequestStatus(SendMatingRequestParameters parameters);
}

class PetMatingRemoteDataSourceImpl implements PetMatingRemoteDataSource {

  @override
  Future<List<PetData>> getAvailablePets(String specieId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: getAvailablePetsEndPoint,
      );
      return List<PetData>.from(result.data['data']['result'].map((x) => PetData.fromJson(x)));
    } on DioException catch (failure) {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromJson(failure.response?.data));
    }
  }


  @override
  Future<String> sendMatingRequest(SendMatingRequestParameters p) async {
    try {
      final result = await DioFinalHelper.postData(
        method: sendMatingRequestEndPoint,
        data: {
          "petFrienId": p.targetPetId,
          "myPetId": p.senderPetId,
        },
      );
      return result.data['message'];
    } on DioException catch (failure) {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromJson(failure.response?.data));
    }
  }



  @override
  Future<void> updateSentRequestStatus(SendMatingRequestParameters p) async {
    try {
      await DioFinalHelper.postData(
        method: cancelRequestEndPoint,
        data: {
          "friendPetId": p.targetPetId,
          "myPetId": p.senderPetId,
        },
      );
    } on DioException catch (failure) {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromJson(failure.response?.data));
    }
  }
}
