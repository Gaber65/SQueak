import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/empty_chats_widget.dart';
import 'package:squeak/features/friendship/presentation/widgets/friends_tab.dart';
import 'package:squeak/features/friendship/presentation/widgets/section_header_widget.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/mating_chat_list_tile.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetFriendsCubit, PetFriendsState>(
      builder: (context, state) {
        final activePet = SwitchProfileCubit.get(context).activeProfile?.pet;

        if (state is ChatsLoading) {
          return DogLoadingStateWidget(
            theme: Theme.of(context),
            isDark: Theme.of(context).brightness == Brightness.dark,
            s: S.of(context),
            text: S.of(context).loadingPetsChats,
          );
        } else if (state is ChatsLoadFailed) {
          return _buildErrorState(context, state.message);
        } else if (state is ChatsLoaded) {
          if (state.chats.isEmpty) {
            return const EmptyChatsWidget();
          }
          return _buildChatsList(context, state.chats, activePet?.petId ?? '');
        }
        return const EmptyChatsWidget();
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            isArabic() ? 'فشل تحميل المحادثات' : 'Failed to load chats',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              final activePet =
                  SwitchProfileCubit.get(context).activeProfile?.pet;
              if (activePet?.petId != null) {
                PetFriendsCubit.get(
                  context,
                ).loadChats(petId: activePet!.petId!);
              }
            },
            icon: const Icon(Icons.refresh),
            label: Text(isArabic() ? 'حاول مرة أخرى' : 'Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(
    BuildContext context,
    List<ChatEntity> chats,
    String petId,
  ) {
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
              child: MatingChatListTile(
                chat: entry.value,
                petId: petId,
                onNavigateComplete: () async {
                  if (petId.isNotEmpty) {
                    await PetFriendsCubit.get(context).loadChats(petId: petId);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

