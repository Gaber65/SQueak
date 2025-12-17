import 'package:dartz/dartz.dart';
import 'package:squeak/features/friendship/domain/usecases/cancel_friendship.dart';
import 'package:squeak/features/friendship/domain/usecases/unblock_friend.dart';
import 'package:squeak/features/friendship/domain/usecases/send_pet_request.dart';
import 'package:squeak/features/friendship/domain/usecases/update_pet_request.dart';
import 'package:squeak/features/friendship/domain/entities/send_friend_message_parameters.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../core/error/failure.dart';
import '../entities/pet_friend_request_entity.dart';
import '../usecases/delete_friendship.dart';

abstract class PetFriendRepository {
  Future<Either<Failure, bool>> sendRequest(SendPetRequestParams params);
  Future<Either<Failure, bool>> updateRequest(UpdatePetRequestParams params);
  Future<Either<Failure, List<PetFriendRequestEntity>>> getMyRequests(
    String myPetId,
  );
  Future<Either<Failure, List<PetEntities>>> getMyFriends(String myPetId);
  Future<Either<Failure, List<PetFriendRequestEntity>>> getBlockedFriends(
    String myPetId,
  );
  Future<Either<Failure, bool>> blockFriend(UnblockFriendParams params);
  Future<Either<Failure, bool>> unblockFriend(UnblockFriendParams params);
  Future<Either<Failure, bool>> cancelFriendship(CancelFriendshipParams params);
  Future<Either<Failure, bool>> deleteFriendShip(DeleteFriendShipParams params);
  Future<Either<Failure, List<PetEntities>>> searchFriends(
    String speciesId, {
    String? name,
    int? page,
    int? pageSize,
  });
  Future<Either<Failure, List<PetEntities>>> getSentRequests(String myPetId);
  Future<Either<Failure, Map<String, dynamic>>> sendFriendMessage(
    SendFriendPetMessageParameters params,
  );
}
