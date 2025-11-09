import 'package:dartz/dartz.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';

class UnblockFriendUseCase extends BaseUseCase<bool, UnblockFriendParams> {
  final PetFriendRepository repository;
  UnblockFriendUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnblockFriendParams params) async {
    return await repository.unblockFriend(params);
  }
}

class UnblockFriendParams {
  final String myPetId;
  final String friendId;

  UnblockFriendParams({required this.myPetId, required this.friendId});

  Map<String, dynamic> toJson() {
    return {
      "myPetId": myPetId,
      "myFrienPetId": friendId,
    };
  }

}