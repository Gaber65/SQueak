import 'package:dio/dio.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/friendship/data/models/pet_friend_model.dart';
import 'package:squeak/features/friendship/domain/usecases/cancel_friendship.dart';
import 'package:squeak/features/friendship/domain/usecases/send_pet_request.dart';
import 'package:squeak/features/friendship/domain/usecases/unblock_friend.dart';
import 'package:squeak/features/friendship/domain/usecases/update_pet_request.dart';
import 'package:squeak/features/friendship/domain/entities/send_friend_message_parameters.dart';
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
  Future<Map<String, dynamic>> sendFriendMessage(
    SendFriendPetMessageParameters params,
  );
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
      // print(result.data);
      // print('-------------------------------------------');

      final data = result.data['data'];

      // تحقق لو data Map وفيها key 'result'
      final dynamic jsonToParse =
          (data is Map && data.containsKey('result')) ? data['result'] : data;

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
      () {
        // Debug: show the request endpoint and body for sendRequest
        print('POST $sendRequestEndPoint -> body: ${{"petId": params.petId, "friendPetId": params.friendPetId}}');
        return DioFinalHelper.postData(
          method: sendRequestEndPoint,
          data: {"petId": params.petId, "friendPetId": params.friendPetId},
        );
      },
      (json) => true,
    );
  }

  @override
  Future<bool> updateRequest(UpdatePetRequestParams params) async {
    return _handleRequest(
      () {
        // Debug: show the request endpoint and body for updateRequest
        print('PUT $updateRequestEndPoint -> body: ${{"statues": params.status, '"petFriendShipRequestId"': params.requestId}}');
        return DioFinalHelper.putData(
          method: updateRequestEndPoint,
          data: {
            "statues": params.status,
            'petFriendShipRequestId': params.requestId,
          },
        );
      },
      (json) => true,
    );
  }

  @override
  Future<List<PetFriendModel>> getMyRequests(String petId) async {
    final endpoint = "$getMyRequestsEndPoint$petId";
    // Debug: show GET endpoint for getMyRequests
    print('GET $endpoint');
    return _handleRequest(
      () => DioFinalHelper.getData(method: endpoint),
      (json) => (json as List).map((e) => PetFriendModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<PetData>> getMyFriends(String petId) async {
    final endpoint = "$getMyFriendsEndPoint$petId";
    // Debug: show GET endpoint for getMyFriends
    print('GET $endpoint');
    return _handleRequest(
      () => DioFinalHelper.getData(method: endpoint),
      (json) => (json as List).map((e) => PetData.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<PetFriendModel>> getBlockedFriends(String petId) async {
    try {
      final endpoint = "$getBlockedFriendsEndPoint$petId";
      // Debug: show GET endpoint for getBlockedFriends
      print('GET $endpoint');
      final result = await DioFinalHelper.getData(
        method: endpoint,
      );
      final data = result.data['data'];
      if (data is Map && data.containsKey('petFriendShipDTOs')) {
        final List<dynamic> friendsList = data['petFriendShipDTOs'] as List;
        return friendsList.map((e) {
          return PetFriendModel.fromJson(e);
        }).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<bool> blockFriend(UnblockFriendParams params) async {
    return _handleRequest(
      () {
        // Debug: show POST endpoint and body for blockFriend
        print('POST $blockFriendEndPoint -> body: ${{"myPetId": params.myPetId, "petFriendId": params.friendId}}');
        return DioFinalHelper.postData(
          method: blockFriendEndPoint,
          data: {"myPetId": params.myPetId, "petFriendId": params.friendId},
        );
      },
      (json) => true,
    );
  }

  @override
  Future<bool> unblockFriend(UnblockFriendParams params) async {
    return _handleRequest(
      () {
        // Debug: show POST endpoint and body for unblockFriend
        print('POST $unblockFriendEndPoint -> body: ${{"myPetId": params.myPetId, "myFrienPetId": params.friendId}}');
        return DioFinalHelper.postData(
          method: unblockFriendEndPoint,
          data: {"myPetId": params.myPetId, "myFrienPetId": params.friendId},
        );
      },
      (json) => true,
    );
  }

  @override
  Future<bool> cancelFriendship(CancelFriendshipParams params) async {
    return _handleRequest(
      () {
        // Debug: show POST endpoint and body for cancelFriendship
        print('POST $cancelFriendshipEndPoint -> body: ${{"myPetId": params.myPetId, "peFriendId": params.friendId}}');
        return DioFinalHelper.postData(
          method: cancelFriendshipEndPoint,
          data: {"myPetId": params.myPetId, "peFriendId": params.friendId},
        );
      },
      (json) => true,
    );
  }

  // {
  // "petId": "46de4602-54bb-4dd9-ab56-220ced66936f",
  // "friendPetId": "c24afc76-fe8b-4d6a-9019-c3a83af95c8d"
  // }
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

    final uri = Uri.parse(
      searchFriendsEndPoint,
    ).replace(queryParameters: queryParams);

    // Debug: show GET endpoint for searchFriends (with query params)
    print('GET ${uri.toString()}');
    return _handleRequest(
      () => DioFinalHelper.getData(method: uri.toString()),
      (json) => (json as List).map((e) => PetData.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<PetData>> getSentRequests(String myPetId) async {
    final endpoint = "$getSentRequestsEndPoint$myPetId";
    // Debug: show GET endpoint for getSentRequests
    print('GET $endpoint');
    return _handleRequest(
      () => DioFinalHelper.getData(method: endpoint),
      (json) => (json as List).map((e) => PetData.fromJson(e)).toList(),
    );
  }

  @override
  Future<Map<String, dynamic>> sendFriendMessage(
    SendFriendPetMessageParameters params,
  ) async {
    try {
      final data = params.toJson();

      // Debug: show POST endpoint and body for sendFriendMessage
      print('POST $sendMassageEndPoint -> body: $data');
      final response = await DioFinalHelper.postData(
        method: sendMassageEndPoint,
        data: data,
      );
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }


}
