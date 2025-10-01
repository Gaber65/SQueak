import 'package:dio/dio.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../models/pet_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetData>> getOwnerPets();
  Future<List<BreedData>> getAllBreeds();
  Future<List<BreedData>> getBreedsBySpeciesId(String speciesId);
  Future<List<BreedData>> getAllSpecies();
  Future<PetData> createPet(PetEntities pet);
  Future<PetData> updatePet(String id, PetData pet);
  Future<void> deletePet(String id);
  Future<List<PetData>> mergePets(List<String> ids);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  @override
  Future<List<PetData>> getOwnerPets() async {
    try {
      final response = await DioFinalHelper.getData(
        method: getOwnerPetEndPoint,
        language: true,
      );
      return (response.data['data']['petsDto'] as List)
          .map((e) => PetData.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<BreedData>> getAllBreeds() async {
    try {
      final response = await DioFinalHelper.getData(
        method: allBreed,
        language: false,
      );
      return (response.data['data']['breedDto'] as List)
          .map((x) => BreedData.fromJson(x))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<BreedData>> getBreedsBySpeciesId(String speciesId) async {
    try {
      final response = await DioFinalHelper.getData(
        method: allBreedBySpeciesId + speciesId,
        language: false,
      );
      return (response.data['data']['breedDto'] as List)
          .map((x) => BreedData.fromJson(x))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<BreedData>> getAllSpecies() async {
    try {
      final response = await DioFinalHelper.getData(
        method: allSpeciesEndPoint,
        language: false,
      );
      return (response.data['data']['speciesDtos'] as List)
          .map((x) => BreedData.fromJson(x))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<PetData> createPet(PetEntities pet) async {
    try {
      final response = await DioFinalHelper.postData(
        method: addPetEndPint,
        data: pet.toJson(),
      );
      return PetData.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<PetData> updatePet(String id, PetData pet) async {
    try {
      final response = await DioFinalHelper.patchData(
        method: updatePetEndPint + id,
        data: pet.toJson(),
      );
      return PetData.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> deletePet(String id) async {
    try {
      await DioFinalHelper.deleteData(method: deletePetEndPint + id);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
  
  @override
  Future<List<PetData>> mergePets(List<String> ids)async {
    try{
      final response = await DioFinalHelper.postData(
        method: mergePetsEndPoint,
        data: {
          "petIds": ids,
        },
      );
      return (response.data['data']['petsDto'] as List)
          .map((e) => PetData.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  /// merge pets

}
