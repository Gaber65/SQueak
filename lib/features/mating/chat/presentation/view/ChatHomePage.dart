import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/chat/presentation/view/ChatListItem.dart';

import '../controllers/chat_list_cubit.dart';
import '../controllers/chat_list_state.dart';
import 'chat_app_cubit.dart';
import 'chat_app_state.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  void initState() {
    super.initState();


    _loadChats();
  }

  void _loadChats() {
    final chatAppCubit = context.read<ChatAppCubit>();
    final chatListCubit = context.read<ChatListCubit>();
    chatListCubit.loadChats(chatAppCubit.petId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          BlocBuilder<ChatAppCubit, ChatAppState>(
            builder: (context, state) {
              final cubit = context.read<ChatAppCubit>();
              final isConnected = cubit.generalHub.isConnected;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isConnected ? Icons.cloud_done : Icons.cloud_off,
                  color: isConnected ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatAppCubit, ChatAppState>(
        listener: (context, state) {
          if (state is ChatAppError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          // Refresh chat list on relevant events
          if (state is UnreadCountUpdated ||
              state is MessageReceived ||
              state is FriendOnlineStatusChanged) {
            _loadChats();
          }
        },
        builder: (context, state) {
          if (state is ChatAppLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return BlocBuilder<ChatListCubit, ChatListState>(
            builder: (context, chatListState) {
              if (chatListState is ChatListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (chatListState is ChatListError) {
                return Center(child: Text(chatListState.message));
              }

              if (chatListState is ChatListLoaded) {
                final chats = chatListState.chats;

                if (chats.isEmpty) {
                  return const Center(child: Text('No chats available'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadChats(),
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final cubit = context.read<ChatAppCubit>();

                      return ChatListItemNew(
                        chat: chat,
                        isOnline: cubit.onlineFriends[chat.petId] ?? false,
                        isTyping: cubit.typingIndicators[chat.petId] ?? false,
                        unreadCount: cubit.unreadCounts[chat.id] ?? chat.unreadedCount,
                      );
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
