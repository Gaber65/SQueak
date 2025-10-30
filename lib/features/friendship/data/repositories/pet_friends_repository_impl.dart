// data/repositories/pet_friend_repository_impl.dart
import 'package:dartz/dartz.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../../domain/entities/pet_friend_request_entity.dart';
import '../../domain/entities/send_friend_message_parameters.dart';
import '../../domain/usecases/update_pet_request.dart';



class PetFriendRepositoryImpl implements PetFriendRepository {
  final PetFriendRemoteDataSource remoteDataSource;

  PetFriendRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> sendRequest(
    SendPetRequestParams params,
  ) async {
    try {
      final result = await remoteDataSource.sendRequest(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> updateRequest(
    UpdatePetRequestParams params,
  ) async {
    try {
      final result = await remoteDataSource.updateRequest(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<PetFriendRequestEntity>>> getMyRequests(
    String petId,
  ) async {
    try {
      final result = await remoteDataSource.getMyRequests(petId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<PetEntities>>> getMyFriends(
    String petId,
  ) async {
    try {
      final result = await remoteDataSource.getMyFriends(petId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<PetFriendRequestEntity>>> getBlockedFriends(
    String petId,
  ) async {
    try {
      final result = await remoteDataSource.getBlockedFriends(petId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> blockFriend(UnblockFriendParams params) async {
    try {
      final result = await remoteDataSource.blockFriend(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> unblockFriend(
    UnblockFriendParams params,
  ) async {
    try {
      final result = await remoteDataSource.unblockFriend(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelFriendship(
    CancelFriendshipParams params,
  ) async {
    try {
      final result = await remoteDataSource.cancelFriendship(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<PetEntities>>> searchFriends(
    String speciesId, {
    String? name,
    int? page,
    int? pageSize,
  }) async {
    try {
      final result = await remoteDataSource.searchFriends(
        speciesId: speciesId,
        name: name,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<PetEntities>>> getSentRequests(
    String myPetId,
  ) async {
    try {
      final result = await remoteDataSource.getSentRequests(myPetId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendFriendMessage(
    SendFriendPetMessageParameters params,
  ) async {
    try {
      final result = await remoteDataSource.sendFriendMessage(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
