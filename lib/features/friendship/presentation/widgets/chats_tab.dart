import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/empty_chats_widget.dart';
import 'package:squeak/features/friendship/presentation/widgets/friends_tab.dart';
import 'package:squeak/features/friendship/presentation/widgets/section_header_widget.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_screen.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetFriendsCubit, PetFriendsState>(
      builder: (context, state) {
        final activePet = SwitchProfileCubit.get(context).activeProfile?.pet;

        if (state is ChatsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChatsLoadFailed) {
          return _buildErrorState(context, state.message);
        } else if (state is ChatsLoaded) {
          if (state.chats.isEmpty) {
            return const EmptyChatsWidget();
          }
          return _buildChatsList(context, state.chats, activePet?.petId ?? '');
        }

        // Default: show empty state
        return const EmptyChatsWidget();
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            isArabic() ? 'فشل تحميل المحادثات' : 'Failed to load chats',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final activePet = SwitchProfileCubit.get(context).activeProfile?.pet;
              if (activePet?.petId != null) {
                PetFriendsCubit.get(context).loadChats(petId: activePet!.petId!);
              }
            },
            icon: const Icon(Icons.refresh),
            label: Text(isArabic() ? 'حاول مرة أخرى' : 'Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(BuildContext context, List<ChatEntity> chats, String petId) {
    return RefreshIndicator(
      onRefresh: () async {
        if (petId.isNotEmpty) {
          await PetFriendsCubit.get(context).loadChats(petId: petId);
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            icon: IconlyBold.chat,
            title: isArabic() ? 'محادثاتي' : 'My Chats',
            count: chats.length,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(height: 16),
          ...chats.asMap().entries.map(
            (entry) => AnimatedItem(
              index: entry.key,
              child: _ChatListItem(
                chat: entry.value,
                petId: petId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatEntity chat;
  final String petId;

  const _ChatListItem({
    required this.chat,
    required this.petId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            debugPrint('=================Conversation id==========================');
            debugPrint('Conversation id: ${chat.id}'); 
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatingChatDetailScreen(chat: chat),
              ),
            );
            // Reload chats after returning from chat screen
            if (petId.isNotEmpty) {
              PetFriendsCubit.get(context).loadChats(petId: petId);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                _buildAvatar(chat, theme, isDark),
                const SizedBox(width: 12),
                
                // Chat info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatFacebookTimePost(chat.lastMessageSendDateTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status badges
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (chat.completeMarriageStatues)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFFC371)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.favorite, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Mating',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (chat.isBlock)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.block, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              isArabic() ? 'محظور' : 'Blocked',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!chat.completeMarriageStatues && !chat.isBlock)
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatEntity chat, ThemeData theme, bool isDark) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Builder(
          builder: (context) {
            final imagePath = chat.image;
            if (imagePath == null || imagePath.isEmpty) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor.withOpacity(0.2),
                      ColorManager.primaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.pets,
                  color: ColorManager.primaryColor,
                  size: 28,
                ),
              );
            }

            // Otherwise try to load the network image and fallback on error
            return Image.network(
              imageUrl + imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        ColorManager.primaryColor.withOpacity(0.2),
                        ColorManager.primaryColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.pets,
                    color: ColorManager.primaryColor,
                    size: 28,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
