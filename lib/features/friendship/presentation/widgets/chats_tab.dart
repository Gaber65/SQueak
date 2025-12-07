import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/section_header_widget.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/chat_widgets/mating_chat_list_tile.dart';
import 'package:squeak/features/mating/chat/presentation/view/chat_app_cubit.dart';
import 'package:squeak/features/mating/chat/presentation/view/chat_app_state.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  String? _currentActivePetId;

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

    _currentActivePetId = activePet!.petId;

    print('📋 [ChatsTab] Building ChatsTab for petId: ${activePet.petId}');
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
                // Refresh chat list on relevant SignalR events
                if (chatAppState is UnreadCountUpdated ||
                    chatAppState is MessageReceived ||
                    chatAppState is FriendOnlineStatusChanged ||
                    chatAppState is NewMessageDetected) {
                  print(
                    '🔄 [ChatsTab] Received event from GeneralHub, refreshing chat list',
                  );
                  if (activePet.petId != null) {
                    PetFriendsCubit.get(
                      context,
                    ).loadChats(petId: activePet.petId!);
                  }
                }

                if (chatAppState is ChatAppError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(chatAppState.message)));
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
          return current is FriendOnlineStatusChanged ||
              current is FriendTypingInGeneral ||
              current is UnreadCountUpdated ||
              current is UnreadCountsPolled ||
              current is ChatAppConnected;
        },
        builder: (context, chatAppState) {
          final chatAppCubit = context.read<ChatAppCubit>();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildChatsHeader(chats.length),
              const SizedBox(height: 16),
              ...chats.map(
                (chat) => MatingChatListTile(
                  chat: chat,
                  petEntities: activePet,
                  isOnline: chatAppCubit.onlineFriends[chat.petId] ?? false,
                  isTyping: chatAppCubit.typingIndicators[chat.petId] ?? false,
                  unreadCount: chatAppCubit.unreadCounts[chat.id] ?? 0,
                  onNavigateComplete: () async {
                    if (activePet.petId!.isNotEmpty) {
                      await PetFriendsCubit.get(
                        context,
                      ).loadChats(petId: activePet.petId!);
                    }
                  },
                ),
              ),
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
