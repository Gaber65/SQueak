import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/friendship/domain/entities/friend_request_stats.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';
import 'package:squeak/features/friendship/domain/usecases/update_pet_request.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/usecases/delete_friendship.dart';

class PetFriendsCubit extends Cubit<PetFriendsState> {
  PetFriendsCubit(
    this.getMyFriendsUseCase,
    this.getMyRequestsUseCase,
    this.getSentRequestsUseCase,
    this.searchFriendsUseCase,
    this.sendPetRequestUseCase,
    this.cancelFriendshipUseCase,
    this.unblockFriendUseCase,
    this.updatePetRequestUseCase,
    this.getBlockedFriendsUseCase,
    this.deleteFriendshipUseCase
  ) : super(FriendsInitial());

  static PetFriendsCubit get(BuildContext context) =>
      BlocProvider.of<PetFriendsCubit>(context);

  final GetMyFriendsUseCase getMyFriendsUseCase;
  final GetMyRequestsUseCase getMyRequestsUseCase;
  final GetSentRequestsUseCase getSentRequestsUseCase;
  final SearchFriendsUseCase searchFriendsUseCase;
  final SendPetRequestUseCase sendPetRequestUseCase;
  final CancelFriendshipUseCase cancelFriendshipUseCase;
  final UnblockFriendUseCase unblockFriendUseCase;
  final UpdatePetRequestUseCase updatePetRequestUseCase;
  final GetBlockedFriendsUseCase getBlockedFriendsUseCase;
  final DeleteFriendShipUseCase deleteFriendshipUseCase;

  List<PetEntities> friends = [];
  List<PetEntities> suggestedFriends = [];
  List<PetFriendRequestEntity> pendingRequests = [];
  List<PetEntities> sentRequests = [];
  List<ChatEntity> chats = [];
  List<PetFriendRequestEntity> blockedFriends = [];

  int selectedTab = 0;
  String requestFilter = 'received';

  void changeTab(int tabIndex) {
    selectedTab = tabIndex;
    emit(ChangeTab(tabIndex: tabIndex));
    if (tabIndex == 3) {}
  }

  void changeRequestFilter(String filter) {
    requestFilter = filter;
    emit(ChangeRequestFilter(filter: filter));
  }

  Future<void> getFriends({required String petId}) async {
    emit(FriendsLoading());
    final result = await getMyFriendsUseCase.call(petId);

    result.fold(
      (failure) => emit(FriendsLoadFailed(message: "Failed to load friends")),
      (friends) {
        emit(FriendsLoadSuccess(friends: friends));
        this.friends = friends;
        emit(
          FriendsLoaded(
            friends: friends,
            suggestedFriends: [],
            pendingRequests: [],
            sentRequests: [],
          ),
        );
      },
    );
  }

  Future<void> loadSuggestedFriends({
    required String specieId,
    String? name,
  }) async {
    emit(SuggestedFriendsLoading());
    final result = await searchFriendsUseCase.call(
      SearchFriendsParams(speciesId: specieId, name: name),
    );

    result.fold((_) => emit(SuggestedFriendsError()), (friends) {
      suggestedFriends = friends;
      emit(SuggestedFriendsLoaded(friends: friends));
    });
  }

  Future<void> loadReceivedFriends({required String petId}) async {
    emit(SuggestedFriendsLoading());
    final result = await getMyRequestsUseCase.call(petId);

    result.fold((_) => emit(SuggestedFriendsError()), (friends) {
      pendingRequests = friends;
      emit(ReceivedFriendsLoaded(friends: friends));
    });
  }

  /// Load sent friends
  Future<void> loadSentFriends({required String petId}) async {
    emit(SuggestedFriendsLoading());
    final result = await getSentRequestsUseCase.call(petId);

    result.fold((_) => emit(SuggestedFriendsError()), (friends) {
      sentRequests = friends;
      emit(SuggestedFriendsLoaded(friends: friends));
    });
  }

  /// Send friend request
  Future<void> sendFriendRequest(PetEntities pet, String activeID) async {
    emit(FriendRequestSending());
    final result = await sendPetRequestUseCase.call(
      SendPetRequestParams(petId: activeID, friendPetId: pet.petId!),
    );

    result.fold((_) => emit(FriendRequestFailed()), (_) {
      sentRequests.add(pet);
      emit(FriendRequestSent(pet: pet));
    });
  }

  /// Cancel friend request
  Future<void> cancelRequest(PetEntities pet, String activeID) async {
    emit(FriendRequestCancelling());
    final result = await cancelFriendshipUseCase.call(
      CancelFriendshipParams(myPetId: activeID, friendId: pet.petId!),
    );

    result.fold((_) => emit(FriendRequestCancelFailed()), (_) {
      sentRequests.remove(pet);

      emit(FriendRequestCancelled(pet: pet));
    });
  }

///delete friendship
  Future<void> deleteFriendship(PetEntities pet, String activeID) async {
    emit(DeleteFriendShipLoading());
    try {
      final result = await deleteFriendshipUseCase.call(
        DeleteFriendShipParams(myPetId: activeID, myFrienPetId: pet.petId!),
      );

      result.fold(
        (failure) => emit(DeleteFriendShipFailed(message: failure.error.message)),
        (_) {
          friends.remove(pet);
          emit(DeleteFriendShipSuccess());
        },
      );
    } catch (e) {
      emit(DeleteFriendShipFailed(message: 'Failed to delete friendship: $e'));
    }
  } 
  /// Accept or decline friend request
  Future<void> updateFriendRequest(
    PetFriendRequestEntity pet,
    FriendshipStatus action,
  ) async {
    emit(FriendRequestUpdating());
    final result = await updatePetRequestUseCase.call(
      UpdatePetRequestParams(requestId: pet.id, status: action.index),
    );

    result.fold((_) => emit(FriendRequestUpdateFailed()), (_) {
      if (action == FriendshipStatus.accepted) {
        getFriends(petId: pet.myPetId);
        loadReceivedFriends(petId: pet.myPetId);
      } else {
        pendingRequests.remove(pet);
      }

      emit(FriendRequestUpdated(pet: pet, status: action));
    });
  }

  /// Unblock friend
  Future<void> unblockFriend(PetEntities pet, String activeID) async {
    emit(FriendUnblocking());
    final result = await unblockFriendUseCase.call(
      UnblockFriendParams(friendId: pet.petId!, myPetId: activeID),
    );

    result.fold((_) => emit(FriendUnblockFailed()), (_) {
      emit(FriendUnblocked(pet: pet));
    });
  }

  Future<void> loadChats({required String petId}) async {
    emit(ChatsLoading());

    final getChatsUseCase = sl<GetChatsUseCase>();
    final result = await getChatsUseCase.call(petId);

    result.fold(
      (failure) {
        emit(ChatsLoadFailed(message: failure.error.message));
      },
      (chatsList) {
        chats = chatsList;
        emit(ChatsLoaded(chats: chatsList));
      },
    );
  }

  Future<void> loadBlockedFriends({required String petId}) async {
    emit(BlockedFriendsLoading());
    final result = await getBlockedFriendsUseCase.call(petId);
    result.fold(
      (failure) {
        emit(BlockedFriendsLoadFailed(message: failure.error.message));
      },
      (blockedList) {
        blockedFriends = blockedList;
        emit(BlockedFriendsLoaded(blockedFriends: blockedList));
      },
    );
  }
}
