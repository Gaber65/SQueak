import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';

import '../../../../../core/service/service_locator/service_locator.dart';
import '../controllers/chat_messages_cubit.dart';
import '../controllers/chat_messages_state.dart';
import 'chat_app_cubit.dart';
import 'chat_app_state.dart';

class ChatConversationPage extends StatefulWidget {
  final ChatEntity chat;
  final String petId;

  const ChatConversationPage({
    super.key,
    required this.chat,
    required this.petId,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleTyping(String text, ChatAppCubit cubit) {
    final isCurrentlyTyping = text.isNotEmpty;

    if (isCurrentlyTyping != _isTyping) {
      _isTyping = isCurrentlyTyping;
      cubit.setTyping(conversationId: widget.chat.id, isTyping: _isTyping);
    }
  }

  void _sendMessage(context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatAppCubit = ChatAppCubit.get(context);

    chatAppCubit.sendMessage(
      conversationId: widget.chat.id,
      toPetId: widget.chat.petId,
      description: text,
    );

    _messageController.clear();
    _isTyping = false;
  }

  @override
  void dispose() {
    final chatAppCubit = context.read<ChatAppCubit>();
    chatAppCubit.leaveConversation();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  ChatAppCubit(petId: widget.petId, fullName: '', image: '')
                    ..joinConversation(widget.chat.id)
                    ..markMessagesAsRead(widget.petId),
        ),
        BlocProvider(
          create:
              (context) =>
                  sl<ChatMessagesCubit>()
                    ..loadMessages(widget.chat.id, widget.petId),
        ),
      ],
      child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.name),
                  BlocBuilder<ChatAppCubit, ChatAppState>(
                    builder: (context, state) {
                      final cubit = context.read<ChatAppCubit>();
                      final isOnline =
                          cubit.onlineFriends[widget.chat.petId] ?? false;

                      if (state is FriendTypingInConversation &&
                          state.conversationId == widget.chat.id &&
                          state.isTyping) {
                        return const Text(
                          'typing...',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        );
                      }

                      return Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOnline ? Colors.green : Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocConsumer<ChatAppCubit, ChatAppState>(
                    listener: (context, state) {
                      if (state is MessageReceived &&
                          state.conversationId == widget.chat.id) {
                        // Add new message to list
                        final messagesCubit = context.read<ChatMessagesCubit>();
                        messagesCubit.messagesList.add(state.message);
                        // ignore: invalid_use_of_protected_member
                        messagesCubit.emit(
                          ChatMessagesLoaded(messagesCubit.messagesList),
                        );

                        // Mark as read
                        context.read<ChatAppCubit>().markMessagesAsRead(
                          widget.chat.id,
                        );

                        // Scroll to bottom
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent,
                            );
                          }
                        });
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
                        builder: (context, messagesState) {
                          if (messagesState is ChatMessagesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (messagesState is ChatMessagesError) {
                            return Center(child: Text(messagesState.message));
                          }

                          if (messagesState is ChatMessagesLoaded) {
                            final messages =
                                context.read<ChatMessagesCubit>().messagesList;

                            if (messages.isEmpty) {
                              return const Center(
                                child: Text('No messages yet'),
                              );
                            }

                            return ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isMe = message.toMe == false;

                                return Align(
                                  alignment:
                                      isMe
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isMe ? Colors.blue : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.description,
                                          style: TextStyle(
                                            color:
                                                isMe
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _formatTime(message.createdAt),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    isMe
                                                        ? Colors.white70
                                                        : Colors.black54,
                                              ),
                                            ),
                                            if (isMe) ...[
                                              const SizedBox(width: 4),
                                              Icon(
                                                message.isRead
                                                    ? Icons.done_all
                                                    : Icons.done,
                                                size: 14,
                                                color:
                                                    message.isRead
                                                        ? Colors.blue[200]
                                                        : Colors.white70,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return const SizedBox();
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (value) {
                            _handleTyping(value, ChatAppCubit.get(context));
                          },
                          onSubmitted: (_) => _sendMessage(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(context),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
