import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';
import 'package:squeak/features/friendship/domain/repositories/pet_friends_repository.dart';

class UpdatePetRequestUseCase extends BaseUseCase<bool, UpdatePetRequestParams> {
  final PetFriendRepository repository;
  UpdatePetRequestUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdatePetRequestParams params) async {
    return await repository.updateRequest(params);
  }
}

class UpdatePetRequestParams {
  final String requestId;
  final int status;

  UpdatePetRequestParams({required this.requestId, required this.status});

  Map<String, dynamic> toJson() => {
    "requestId": requestId,
    "status": status,
  };
}