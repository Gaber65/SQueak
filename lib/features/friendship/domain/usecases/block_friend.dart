import 'package:dartz/dartz.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';


class BlockFriendUseCase extends BaseUseCase<bool, UnblockFriendParams> {
  final PetFriendRepository repository;
  BlockFriendUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnblockFriendParams params) async {
    return await repository.blockFriend(params);
  }
}

