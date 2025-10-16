import '../models/pet_mating_model.dart';

abstract class PetMatingLocalDataSource {
  Future<List<PetMatingModel>> getAvailablePets();
  Future<void> cacheAvailablePets(List<PetMatingModel> pets);
  Future<PetMatingModel?> getPetProfile(String petId);
}

class PetMatingLocalDataSourceImpl implements PetMatingLocalDataSource {
  @override
  Future<List<PetMatingModel>> getAvailablePets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PetMatingModel.availablePets;
  }

  @override
  Future<void> cacheAvailablePets(List<PetMatingModel> pets) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<PetMatingModel?> getPetProfile(String petId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PetMatingModel.availablePets.firstWhere(
          (pet) => pet.id == petId,
      orElse: () => throw Exception('Pet not found'),
    );
  }
}