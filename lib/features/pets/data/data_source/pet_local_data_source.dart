import 'dart:convert';
import 'package:squeak/features/auth/get_started/domain/model/create_pets_modell.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../models/pet_model.dart';

abstract class PetLocalDataSource {
  Future<List<PetData>> getCachedPets();
  Future<List<BreedData>> getCachedBreeds();
  Future<void> cachePets(List<PetData> pets);
  Future<void> cacheBreeds(List<BreedData> breeds);
}

class PetLocalDataSourceImpl implements PetLocalDataSource {
  @override
  Future<List<PetData>> getCachedPets() async {
    try {
      final jsonString = CacheHelper.getData('usersPets');
      if (jsonString != null) {
        return List<PetData>.from(
          json.decode(jsonString).map((x) => PetData.fromJson(x)),
        ).where((e) => e.petId != CacheHelper.getData('clintId')).toList();
      }
      return [];
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<BreedData>> getCachedBreeds() async {
    try {
      final jsonString = CacheHelper.getData('allBreeds');
      if (jsonString != null) {
        return List<BreedData>.from(
          json.decode(jsonString).map((x) => BreedData.fromJson(x)),
        );
      }
      return [];
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> cachePets(List<PetData> pets) async {
    try {
      final jsonString = json.encode(pets.map((pet) => pet.toJson()).toList());
      await CacheHelper.saveData('usersPets', jsonString);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> cacheBreeds(List<BreedData> breeds) async {
    try {
      final jsonString = json.encode(
        breeds.map((breed) => breed.toMap()).toList(),
      );
      await CacheHelper.saveData('allBreeds', jsonString);
    } catch (e) {
      throw LocalDatabaseException(errorMessage: e.toString());
    }
  }
}
