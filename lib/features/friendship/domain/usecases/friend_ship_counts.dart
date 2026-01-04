import 'package:dartz/dartz.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_counts_entity.dart';
import 'package:squeak/features/friendship/domain/repositories/pet_friends_repository.dart';

class GetFriendshipCountsUseCase extends BaseUseCase<FriendshipCounts, String> {
  final PetFriendRepository repository;

  GetFriendshipCountsUseCase(this.repository);

  @override
  Future<Either<Failure, FriendshipCounts>> call(String myPetId) async {
    return await repository.getFriendshipCounts(myPetId);
  }
}