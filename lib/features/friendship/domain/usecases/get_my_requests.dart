import 'package:dartz/dartz.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/pet_friend_request_entity.dart';

class GetMyRequestsUseCase extends BaseUseCase<List<PetFriendRequestEntity>, String> {
  final PetFriendRepository repository;
  GetMyRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetFriendRequestEntity>>> call(String myPetId) async {
    return await repository.getMyRequests(myPetId);
  }
}