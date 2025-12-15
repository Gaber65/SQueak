import 'package:dartz/dartz.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';

class DeleteFriendShipUseCase
    extends BaseUseCase<bool, DeleteFriendShipParams> {
  final PetFriendRepository repository;
  DeleteFriendShipUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteFriendShipParams params) async {
    return await repository.deleteFriendShip(params);
  }
}

class DeleteFriendShipParams {
  final String myPetId;
  final String myFrienPetId;

  DeleteFriendShipParams({required this.myPetId, required this.myFrienPetId});
}
