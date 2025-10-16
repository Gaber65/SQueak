import 'package:dartz/dartz.dart';
import 'package:squeak/features/friendship/domain/repositories/pet_friends_repository.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/pet_friend_request_entity.dart';

class GetBlockedFriendsUseCase extends BaseUseCase<List<PetFriendRequestEntity>, String> {
  final PetFriendRepository repository;
  GetBlockedFriendsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetFriendRequestEntity>>> call(String myPetId) async {
    return await repository.getBlockedFriends(myPetId);
  }
}
