import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/section_header_widget.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/data/models/chat_model.dart';
import 'package:squeak/features/mating/chat/data/models/message_model.dart';
import 'package:squeak/features/mating/chat/domain/entities/message_status.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_widgets/mating_chat_list_tile.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_app_cubit.dart';
import 'package:squeak/features/mating/chat/presentation/controllers/chat_app_state.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activePet = SwitchProfileCubit.get(context).activeProfile?.pet;

    if (activePet?.petId == null) {
      return Center(child: CircularProgressIndicator());
    }

    print('📋 [ChatsTab] Building ChatsTab for petId: ${activePet!.petId}');
    print(
      '📡 [ChatsTab] This screen uses GeneralHub only (no ConversationHub)',
    );

    return BlocConsumer<PetFriendsCubit, PetFriendsState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<ChatEntity> chats = [];
        if (state is ChatsLoaded) {
          chats = state.chats;
          print('✅ [ChatsTab] Loaded ${chats.length} chats');
        }

        return MultiBlocListener(
          listeners: [
            BlocListener<ChatAppCubit, ChatAppState>(
              listener: (context, chatAppState) {
                // Handle new message detection from SignalR
                if (chatAppState is NewMessageDetected) {
                  print(
                    '📩 [ChatsTab] NewMessageDetected for conversation: ${chatAppState.conversationId}',
                  );
                  print('   Content: ${chatAppState.contentMessage}');
                  print('   Has image: ${chatAppState.imageMessage}');
                  print('   Has video: ${chatAppState.videoMessage}');
                  print('   Has file: ${chatAppState.fileMessage}');

                  // Find the chat that matches this conversation
                  final chatIndex = chats.indexWhere(
                    (chat) => chat.id == chatAppState.conversationId,
                  );

                  if (chatIndex != -1) {
                    final oldChat = chats[chatIndex] as ChatModel;
                    print('✅ [ChatsTab] Found matching chat: ${oldChat.name}');

                    // Determine if it's audio (when not image, video, or file)
                    final isAudio =
                        !chatAppState.imageMessage &&
                        !chatAppState.videoMessage &&
                        !chatAppState.fileMessage &&
                        chatAppState.contentMessage.isEmpty;

                    // Create new message model for the last message
                    final newLastMessage = MessageModel(
                      id: '',
                      description: chatAppState.contentMessage,
                      image: chatAppState.imageMessage ? 'temp_image' : null,
                      video: chatAppState.videoMessage ? 'temp_video' : null,
                      audio: isAudio ? 'temp_audio' : null,
                      file: chatAppState.fileMessage ? 'temp_file' : null,
                      status: MessageStatus.sent,
                      fromUserId: chatAppState.fromPetId,
                      toUserId: activePet.petId ?? '',
                      createdAt: DateTime.now(),
                      toMe: true, // Message is coming to me
                    );

                    // Create updated chat with new last message
                    final updatedChat = ChatModel(
                      id: oldChat.id,
                      isGroup: oldChat.isGroup,
                      isPetChat: oldChat.isPetChat,
                      name: oldChat.name,
                      image: oldChat.image,
                      groupImage: oldChat.groupImage,
                      petId: oldChat.petId,
                      matingId: oldChat.matingId,
                      completeMarriageStatues: oldChat.completeMarriageStatues,
                      createdAt: oldChat.createdAt,
                      lastMessageSendDateTime: DateTime.now().toIso8601String(),
                      isBlock: oldChat.isBlock,
                      isBlockedByMe: oldChat.isBlockedByMe,
                      isBlockedByOther: oldChat.isBlockedByOther,
                      isReadOnly: oldChat.isReadOnly,
                      unreadedCount: oldChat.unreadedCount,
                      lastMessage: newLastMessage,
                    );

                    // Create new list with updated chat
                    final updatedChats = List<ChatEntity>.from(chats);
                    updatedChats[chatIndex] = updatedChat;

                    // Trigger rebuild
                    PetFriendsCubit.get(
                      context,
                    ).emit(ChatsLoaded(chats: updatedChats));

                    print(
                      '✅ [ChatsTab] Updated last message for ${oldChat.name}',
                    );
                  } else {
                    print(
                      '⚠️ [ChatsTab] No matching chat found for conversation: ${chatAppState.conversationId}',
                    );
                  }
                }
              },
            ),
          ],
          child: _buildChatsList(context, chats, activePet),
        );
      },
    );
  }

  Widget _buildChatsList(
    BuildContext context,
    List<ChatEntity> chats,
    PetEntities activePet,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        if (activePet.petId!.isNotEmpty) {
          await PetFriendsCubit.get(context).loadChats(petId: activePet.petId!);
        }
      },
      child: BlocBuilder<ChatAppCubit, ChatAppState>(
        buildWhen: (previous, current) {
          // Rebuild when online status, typing status, or unread count changes
          final shouldRebuild =
              current is FriendOnlineStatusChanged ||
              current is FriendTypingInGeneral ||
              current is UnreadCountUpdated ||
              current is UnreadCountsPolled ||
              current is NewMessageDetected ||
              current is ChatAppConnected;

          if (shouldRebuild) {
            print(
              '🔄 [ChatsTab] Rebuilding chat list due to: ${current.runtimeType}',
            );
          }

          return shouldRebuild;
        },
        builder: (context, chatAppState) {
          final chatAppCubit = context.read<ChatAppCubit>();

          print('🏗️ [ChatsTab] Building chat list with ${chats.length} chats');

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildChatsHeader(chats.length),
              const SizedBox(height: 16),
              ...chats.map((chat) {
                // الحصول على البيانات من القاموس مباشرة
                // Get data from dictionary directly
                final isOnline = chatAppCubit.generalHub.isPetOnlineFromDict(
                  chat.petId,
                );

                return MatingChatListTile(
                  chat: chat,
                  petEntities: activePet,
                  isOnline: isOnline,
                  isTyping: chatAppCubit.typingIndicators[chat.petId] ?? false,
                  unreadCount: chatAppCubit.unreadCounts[chat.id] ?? 0,
                  onNavigateComplete: () async {
                    if (activePet.petId!.isNotEmpty) {
                      await PetFriendsCubit.get(
                        context,
                      ).loadChats(petId: activePet.petId!);
                    }
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatsHeader(int chatCount) {
    return Row(
      children: [
        Expanded(
          child: SectionHeader(
            icon: IconlyBold.chat,
            title: isArabic() ? 'محادثاتي' : 'My Chats',
            count: chatCount,
            color: ColorManager.primaryColor,
          ),
        ),
        // Quick actions
        _buildQuickActions(),
      ],
    );
  }

  Widget _buildQuickActions() {
    return BlocBuilder<ChatAppCubit, ChatAppState>(
      builder: (context, state) {
        final isConnected = state is ChatAppConnected;
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.orange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:
                    isConnected
                        ? Colors.green.withOpacity(0.5)
                        : Colors.orange.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }

  bool isArabic() {
    return Localizations.localeOf(context).languageCode == 'ar';
  }
}
