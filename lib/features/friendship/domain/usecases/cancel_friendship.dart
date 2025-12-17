import 'package:dartz/dartz.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';

class CancelFriendshipUseCase
    extends BaseUseCase<bool, CancelFriendshipParams> {
  final PetFriendRepository repository;
  CancelFriendshipUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CancelFriendshipParams params) async {
    return await repository.cancelFriendship(params);
  }
}

class CancelFriendshipParams {
  final String myPetId;
  final String friendId;

  CancelFriendshipParams({required this.myPetId, required this.friendId});
}
