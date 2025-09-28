import 'package:dartz/dartz.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';
import 'package:squeak/features/friendship/domain/repositories/pet_friends_repository.dart';


class SendPetRequestUseCase extends BaseUseCase<bool, SendPetRequestParams> {
  final PetFriendRepository repository;

  SendPetRequestUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendPetRequestParams params) async {
    return await repository.sendRequest(params);
  }
}

class SendPetRequestParams {
  final String petId;
  final String friendPetId;

  SendPetRequestParams({required this.petId, required this.friendPetId});

  Map<String, dynamic> toJson() => {
    "petId": petId,
    "friendPetId": friendPetId,
  };
}
