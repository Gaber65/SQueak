import 'package:dio/dio.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/friendship/data/models/pet_friend_model.dart';
import 'package:squeak/features/friendship/domain/usecases/cancel_friendship.dart';
import 'package:squeak/features/friendship/domain/usecases/send_pet_request.dart';
import 'package:squeak/features/friendship/domain/usecases/unblock_friend.dart';
import 'package:squeak/features/friendship/domain/usecases/update_pet_request.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';

abstract class PetFriendRemoteDataSource {
  Future<bool> sendRequest(SendPetRequestParams params);
  Future<bool> updateRequest(UpdatePetRequestParams params);
  Future<List<PetFriendModel>> getMyRequests(String petId);
  Future<List<PetData>> getMyFriends(String petId);
  Future<List<PetFriendModel>> getBlockedFriends(String petId);
  Future<bool> blockFriend(UnblockFriendParams params);
  Future<bool> unblockFriend(UnblockFriendParams params);
  Future<bool> cancelFriendship(CancelFriendshipParams params);
  Future<List<PetData>> searchFriends({
    required String speciesId,
    String? name,
    int? page,
    int? pageSize,
  });
  Future<List<PetData>> getSentRequests(String myPetId);
}

class PetFriendRemoteDataSourceImpl implements PetFriendRemoteDataSource {
  /// 🔹 Generic handler
  /// 🔹 Generic handler
  Future<T> _handleRequest<T>(
      Future<Response> Function() request,
      T Function(dynamic json) fromJson,
      ) async {
    try {
      final result = await request();
      print(result.data);
      print('-------------------------------------------');

      final data = result.data['data'];

      // تحقق لو data Map وفيها key 'result'
      final dynamic jsonToParse = (data is Map && data.containsKey('result'))
          ? data['result']
          : data;

      return fromJson(jsonToParse);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }


  @override
  Future<bool> sendRequest(SendPetRequestParams params) async {
    return _handleRequest(
      () => DioFinalHelper.postData(
        method: sendRequestEndPoint,
        data: {"petId": params.petId, "friendPetId": params.friendPetId},
      ),
      (json) => true,
    );
  }

  @override
  Future<bool> updateRequest(UpdatePetRequestParams params) async {
    return _handleRequest(
      () => DioFinalHelper.putData(
        method: updateRequestEndPoint,
        data: {
          "statues": params.status,
          'petFriendShipRequestId': params.requestId,
        },
      ),
          (json) => true,
    );
  }

  @override
  Future<List<PetFriendModel>> getMyRequests(String petId) async {
    return _handleRequest(
      () => DioFinalHelper.getData(method: "$getMyRequestsEndPoint$petId"),
      (json) => (json as List).map((e) => PetFriendModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<PetData>> getMyFriends(String petId) async {
    return _handleRequest(
      () => DioFinalHelper.getData(method: "$getMyFriendsEndPoint$petId"),
      (json) => (json as List).map((e) => PetData.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<PetFriendModel>> getBlockedFriends(String petId) async {
    return _handleRequest(
      () => DioFinalHelper.getData(method: "$getBlockedFriendsEndPoint$petId"),
      (json) => (json as List).map((e) => PetFriendModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<bool> blockFriend(UnblockFriendParams params) async {
    return _handleRequest(
      () => DioFinalHelper.postData(
        method: blockFriendEndPoint,
        data: {"myPetId": params.myPetId, "petFriendId": params.friendId},
      ),
      (json) => true,
    );
  }

  @override
  Future<bool> unblockFriend(UnblockFriendParams params) async {
    return _handleRequest(
      () => DioFinalHelper.postData(
        method: unblockFriendEndPoint,
        data: {"myPetId": params.myPetId, "myFrienPetId": params.friendId},
      ),
      (json) => true,
    );
  }

  @override
  Future<bool> cancelFriendship(CancelFriendshipParams params) async {
    return _handleRequest(
      () => DioFinalHelper.postData(
        method: cancelFriendshipEndPoint,
        data: {"myPetId": params.myPetId, "myFrienPetId": params.friendId},
      ),
      (json) => true,
    );
  }

  @override
  Future<List<PetData>> searchFriends({
    required String speciesId,
    String? name,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = {
      "speciesId": speciesId,
      if (name != null) "name": name,
      if (page != null) "page": page.toString(),
      if (pageSize != null) "pageSize": pageSize.toString(),
    };

    final uri = Uri.parse(searchFriendsEndPoint).replace(queryParameters: queryParams);

    return _handleRequest(
          () => DioFinalHelper.getData(method: uri.toString()),
          (json) => (json as List).map((e) => PetData.fromJson(e)).toList(),
    );
  }
  @override
  Future<List<PetData>> getSentRequests(String myPetId) async {
    return _handleRequest(
      () => DioFinalHelper.getData(method: "$getSentRequestsEndPoint$myPetId"),
      (json) => (json as List).map((e) => PetData.fromJson(e)).toList(),
    );
  }
}
