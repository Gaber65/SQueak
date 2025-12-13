import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/domain/usecases/get_chats_usecase.dart';
import 'package:squeak/features/mating/chat/domain/entities/message_status.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatsUseCase getChatsUseCase;

  List<ChatEntity> allChats = [];
  Map<String, bool> friendsTyping = {};

  ChatListCubit({required this.getChatsUseCase, required Object signalRService})
    : super(ChatListInitial());

  static ChatListCubit get(context) => BlocProvider.of(context);

  Future<void> loadChats(String petId, {ChatStatus? status}) async {
    emit(ChatListLoading());
    final result = await getChatsUseCase(petId);

    result.fold((failure) => emit(ChatListError(failure.toString())), (chats) {
      allChats = _mergeWithPersistence(chats);
      emit(ChatListLoaded(allChats));
    });
  }

  /// Update chat status locally when friend comes online
  void updateChatOnlineStatus(String petId, bool isOnline) {
    if (!isOnline) return;

    final index = allChats.indexWhere((c) => c.petId == petId);
    if (index != -1) {
      final chat = allChats[index];

      // Only update if last message is sent by me (toMe=false) and status is sent
      if (chat.lastMessage != null &&
          !chat.lastMessage!.toMe &&
          chat.lastMessage!.status == MessageStatus.sent) {
        final updatedMessage = chat.lastMessage!.copyWith(
          status: MessageStatus.delivered,
        );

        // Manual copyWith since ChatEntity doesn't have one
        final updatedChat = ChatEntity(
          id: chat.id,
          isGroup: chat.isGroup,
          isPetChat: chat.isPetChat,
          name: chat.name,
          image: chat.image,
          groupImage: chat.groupImage,
          petId: chat.petId,
          matingId: chat.matingId,
          completeMarriageStatues: chat.completeMarriageStatues,
          createdAt: chat.createdAt,
          lastMessageSendDateTime: chat.lastMessageSendDateTime,
          isBlock: chat.isBlock,
          isBlockedByMe: chat.isBlockedByMe,
          isBlockedByOther: chat.isBlockedByOther,
          isReadOnly: chat.isReadOnly,
          unreadedCount: chat.unreadedCount,
          lastMessage: updatedMessage,
        );

        // Create a new list reference to ensure Bloc emits a change
        final newChats = List<ChatEntity>.from(allChats);
        newChats[index] = updatedChat;
        allChats = newChats;

        emit(ChatListLoaded(allChats));
      }
    }
  }

  /// Refresh chats without showing loading indicator (for real-time updates)
  Future<void> refreshChatsWithoutLoading(String petId) async {
    final result = await getChatsUseCase(petId);

    result.fold(
      (failure) {
        // Silently fail, keep existing data
        print('⚠️ [ChatListCubit] Silent refresh failed: $failure');
      },
      (chats) {
        allChats = _mergeWithPersistence(chats);
        emit(ChatListLoaded(allChats));
      },
    );
  }

  /// Merges new chats with existing chats to preserve 'delivered' status
  /// if the server returns 'sent' but we locally know it's 'delivered'.
  List<ChatEntity> _mergeWithPersistence(List<ChatEntity> newChats) {
    if (allChats.isEmpty) return newChats;

    return newChats.map((newChat) {
      final existingIndex = allChats.indexWhere((c) => c.id == newChat.id);
      if (existingIndex == -1) return newChat;

      final existingChat = allChats[existingIndex];

      // Check if we should preserve existing 'delivered' status
      if (existingChat.lastMessage != null &&
          newChat.lastMessage != null &&
          existingChat.lastMessage!.id ==
              newChat.lastMessage!.id && // Same message
          !existingChat
              .lastMessage!
              .toMe // Sent by me
              ) {
        // If local is DELIVERED and server is SENT, keep local DELIVERED
        if (existingChat.lastMessage!.status == MessageStatus.delivered &&
            newChat.lastMessage!.status == MessageStatus.sent) {
          print(
            '🛡️ [ChatListCubit] Preserving DELIVERED status for chat ${newChat.id} against server SENT',
          );

          final preservedMessage = newChat.lastMessage!.copyWith(
            status: MessageStatus.delivered,
          );

          return ChatEntity(
            id: newChat.id,
            isGroup: newChat.isGroup,
            isPetChat: newChat.isPetChat,
            name: newChat.name,
            image: newChat.image,
            groupImage: newChat.groupImage,
            petId: newChat.petId,
            matingId: newChat.matingId,
            completeMarriageStatues: newChat.completeMarriageStatues,
            createdAt: newChat.createdAt,
            lastMessageSendDateTime: newChat.lastMessageSendDateTime,
            isBlock: newChat.isBlock,
            isBlockedByMe: newChat.isBlockedByMe,
            isBlockedByOther: newChat.isBlockedByOther,
            isReadOnly: newChat.isReadOnly,
            unreadedCount: newChat.unreadedCount,
            lastMessage: preservedMessage,
          );
        }
      }
      return newChat;
    }).toList();
  }

  @override
  Future<void> close() {
    // _signalSubscription?.cancel();
    return super.close();
  }
}
