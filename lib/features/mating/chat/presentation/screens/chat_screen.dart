// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/service/service_locator/service_locator.dart';
import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_status.dart';
import '../../domain/entities/message_entity.dart';
import '../controllers/chat_messages_cubit.dart';
import '../controllers/chat_messages_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_app_bar.dart';

class ProfessionalChatScreen extends StatelessWidget {
  final ChatEntity chat;

  ProfessionalChatScreen({super.key, required this.chat});

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatMessagesCubit>()..loadMessages(chat.id),
      child: BlocConsumer<ChatMessagesCubit, ChatMessagesState>(
        listener: (context, state) {
          if (state is MessageSent) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          var cubit = ChatMessagesCubit.get(context);
          return Scaffold(
            appBar: ChatAppBar(chat: chat),
            body: Column(
              children: [
                // Mating Status Banner
                if (chat.status == ChatStatus.onMating)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink[50]!, Colors.pink[100]!],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(width: 12),
                        Text(
                          'Mating Process Started! 🐾',
                          style: TextStyle(
                            color: Colors.pink[800],
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Messages List
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/chat_background.png'),
                        fit: BoxFit.cover,
                        opacity: 0.1,
                      ),
                    ),
                    child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
                      builder: (context, state) {

                        if (state is ChatMessagesLoading) {
                          return _buildLoadingState();
                        } else if (state is ChatMessagesError) {
                          return _buildErrorState(state);
                        } else if (state is ChatMessagesLoaded) {

                          if(state.messages.isEmpty){
                            return _buildEmptyState();

                          } else{
                            return _buildMessagesList(state.messages);

                          }
                        } else if (state is MessageSending) {
                          return _buildMessagesList([]);
                        } else {
                          return _buildEmptyState();
                        }
                      },
                    ),
                  ),
                ),
                // Message Input
                _buildMessageInput(cubit, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
            'https://lottie.host/7e2c969e-efa7-49b8-a15d-bc46704354a9/3mUd4ks1TD.json',
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading messages...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ChatMessagesError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/confused_dog.png',
            height: 80,
            width: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load messages',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            state.message,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/start_chat.png',
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 20),
          const Text(
            'Start the conversation!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Send a message to begin chatting',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<MessageEntity> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return MessageBubble(message: message);
      },
    );
  }

  Widget _buildMessageInput(ChatMessagesCubit cubit, ChatMessagesState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message... 🐾',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send Button
          BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
            builder: (context, state) {
              return IconButton(
                icon: state is MessageSending
                    ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
                    : Icon(IconlyBold.send, color: ColorManager.primaryColor, size: 20),
                onPressed: _canSendMessage(state) ? () => _sendMessage(cubit) : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getButtonColor(ChatMessagesState state) {
    if (state is MessageSending) {
      return Colors.grey;
    }
    return ColorManager.primaryColor;
  }

  bool _canSendMessage(ChatMessagesState state) {
    return state is! MessageSending && _messageController.text.trim().isNotEmpty;
  }

  void _sendMessage(ChatMessagesCubit cubit) {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      cubit.sendMessage(
        chatId: chat.id,
        text: text,
        isMe: true,
      );
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}