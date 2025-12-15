import 'package:dartz/dartz.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';

class GetSentRequestsUseCase extends BaseUseCase<List<PetEntities>, String> {
  final PetFriendRepository repository;
  GetSentRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetEntities>>> call(String myPetId) async {
    return await repository.getSentRequests(myPetId);
  }
}
