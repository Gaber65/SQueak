import '../models/pet_mating_model.dart';

abstract class PetMatingRemoteDataSource {
  Future<List<PetMatingModel>> getAvailablePets();
  Future<void> sendMatingRequest(String petId, String message);
  Future<void> updatePetStatus(String petId, int status);

}

class PetMatingRemoteDataSourceImpl implements PetMatingRemoteDataSource {
  @override
  Future<List<PetMatingModel>> getAvailablePets() async {
    // Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return PetMatingModel.availablePets;
  }

  @override
  Future<void> sendMatingRequest(String petId, String message) async {
    // Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> updatePetStatus(String petId, int status) async {
    // Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
  }
}